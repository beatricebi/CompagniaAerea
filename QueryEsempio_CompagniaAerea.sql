-- Query di test per CompagniaAereaDB

-- 1 - numero medio di voli per aeroporto
SELECT AVG(numero_voli) AS NumeroMedioVoliPerAeroporto
FROM (
    SELECT aeroporto_partenza_id, COUNT(*) AS numero_voli
    FROM VoliAstratti
    GROUP BY aeroporto_partenza_id
) AS voli_per_aeroporto;

-- 2 - tratte ordinate per popolarità media, dalla più affollata alla meno
WITH PasseggeriPerVolo AS (
    SELECT 
        vs.compagnia_id,
        vs.volo_num,
        vs.data_ora_partenza_prevista,
        va.aeroporto_partenza_id,
        va.aeroporto_arrivo_id,
        COUNT(DISTINCT pp.passeggero_id) AS num_passeggeri
    FROM VoliSpecifici vs
    JOIN VoliAstratti va
      ON vs.compagnia_id = va.compagnia_id
     AND vs.volo_num = va.volo_num
    LEFT JOIN SegmentoPrenotazione sp
      ON sp.compagnia_id = vs.compagnia_id
     AND sp.volo_num = vs.volo_num
     AND CAST(sp.data_ora_partenza_prevista AS DATE) = CAST(vs.data_ora_partenza_prevista AS DATE)
    LEFT JOIN PrenotazioniPasseggeri pp ON sp.prenotazione_id = pp.prenotazione_id
    GROUP BY vs.compagnia_id, vs.volo_num, vs.data_ora_partenza_prevista, va.aeroporto_partenza_id, va.aeroporto_arrivo_id
)
SELECT
    ap.aeroporto_nome AS aeroporto_partenza,
    aa.aeroporto_nome AS aeroporto_arrivo,
    AVG(num_passeggeri) AS media_passeggeri
FROM PasseggeriPerVolo p
JOIN Aeroporti ap ON p.aeroporto_partenza_id = ap.codice_IATA
JOIN Aeroporti aa ON p.aeroporto_arrivo_id = aa.codice_IATA
GROUP BY ap.aeroporto_nome, aa.aeroporto_nome
ORDER BY media_passeggeri DESC;

-- 3 - storico dei voli di un passeggero
SELECT 
    sp.compagnia_id,
    sp.volo_num,
    sp.data_ora_partenza_prevista,
    va.aeroporto_partenza_id,
    va.aeroporto_arrivo_id
FROM SegmentoPrenotazione sp
JOIN PrenotazioniPasseggeri pp ON sp.prenotazione_id = pp.prenotazione_id
JOIN VoliSpecifici vs ON sp.compagnia_id = vs.compagnia_id 
                     AND sp.volo_num = vs.volo_num
                     AND sp.data_ora_partenza_prevista = vs.data_ora_partenza_prevista
JOIN VoliAstratti va ON sp.compagnia_id = va.compagnia_id AND sp.volo_num = va.volo_num
WHERE pp.passeggero_id = 5
ORDER BY sp.data_ora_partenza_prevista DESC;

-- 4 - voli partiti con ritardi di oltre 45 minuti
SELECT 
    vs.compagnia_id,
    vs.volo_num,
    vs.data_ora_partenza_prevista,
    vs.data_ora_partenza_effettiva,
    DATEDIFF(MINUTE, vs.data_ora_partenza_prevista, vs.data_ora_partenza_effettiva) AS ritardo_minuti,
    vs.volo_status
FROM VoliSpecifici vs
WHERE 
    vs.data_ora_partenza_effettiva IS NOT NULL
    AND DATEDIFF(MINUTE, vs.data_ora_partenza_prevista, vs.data_ora_partenza_effettiva) > 45
ORDER BY ritardo_minuti DESC;

-- 5 - numero di posti ancora disponibili sui voli in partenza oggi
WITH PostiOccupatiPerVoloClasse AS (
    SELECT 
        sp.compagnia_id,
        sp.volo_num,
        CAST(sp.data_ora_partenza_prevista AS DATE) AS data_partenza,
        sp.classe_id,
        COUNT(DISTINCT pp.passeggero_id) AS posti_occupati
    FROM SegmentoPrenotazione sp
    JOIN PrenotazioniPasseggeri pp ON sp.prenotazione_id = pp.prenotazione_id
    GROUP BY sp.compagnia_id, sp.volo_num, CAST(sp.data_ora_partenza_prevista AS DATE), sp.classe_id
),

Classi AS (
    SELECT DISTINCT classe_id FROM SegmentoPrenotazione
),

VoliConAereo AS (
    SELECT 
        va.compagnia_id,
        va.volo_num,
        vs.data_ora_partenza_prevista,
        va.aereo_id
    FROM VoliAstratti va
    JOIN VoliSpecifici vs 
      ON va.compagnia_id = vs.compagnia_id 
     AND va.volo_num = vs.volo_num 
     AND vs.data_ora_partenza_prevista = vs.data_ora_partenza_prevista
)

SELECT 
    vs.compagnia_id,
    vs.volo_num,
    vs.data_ora_partenza_prevista,
    c.classe_id,
    COALESCE(pocl.posti_occupati, 0) AS posti_prenotati,
    CASE 
        WHEN c.classe_id = 'J' THEN a.posti_ClasseBusiness
        WHEN c.classe_id = 'Y' THEN a.posti_ClasseEconomy
        ELSE 0
    END AS posti_totali,
    CASE 
        WHEN c.classe_id IN ('J', 'Y') THEN
            CASE 
                WHEN c.classe_id = 'J' THEN a.posti_ClasseBusiness - COALESCE(pocl.posti_occupati, 0)
                WHEN c.classe_id = 'Y' THEN a.posti_ClasseEconomy - COALESCE(pocl.posti_occupati, 0)
            END
        ELSE 0
    END AS posti_disponibili
FROM VoliSpecifici vs
CROSS JOIN Classi c
LEFT JOIN PostiOccupatiPerVoloClasse pocl
    ON vs.compagnia_id = pocl.compagnia_id
    AND vs.volo_num = pocl.volo_num
    AND CAST(vs.data_ora_partenza_prevista AS DATE) = pocl.data_partenza
    AND c.classe_id = pocl.classe_id
JOIN VoliConAereo va
    ON vs.compagnia_id = va.compagnia_id
   AND vs.volo_num = va.volo_num
   AND vs.data_ora_partenza_prevista = va.data_ora_partenza_prevista
JOIN Aereo a ON va.aereo_id = a.aereo_id
WHERE CAST(vs.data_ora_partenza_prevista AS DATE) = CAST(GETDATE() AS DATE)
  AND vs.data_ora_partenza_prevista >= GETDATE()
ORDER BY vs.compagnia_id, vs.volo_num, vs.data_ora_partenza_prevista, c.classe_id;


-- 6 - passeggeri con documenti in scadenza nel prossimo mese 
SELECT 
    p.passeggero_nome,
    p.passeggero_cognome,
    p.passeggero_codice,
    d.documento_tipo,
    d.documento_DataScadenza,
    d.codice_documento
FROM Passeggero p
JOIN DocumentoIdentificativo d ON p.passeggero_id = d.passeggero_id
WHERE d.documento_DataScadenza BETWEEN CAST(GETDATE() AS DATE) AND DATEADD(MONTH, 1, CAST(GETDATE() AS DATE))
ORDER BY d.documento_DataScadenza;

-- 7 - quanti posti sono occupati e quanti ancora disponibili sui voli prenotati
WITH PostiOccupatiPerVoloClasse AS (
    SELECT 
        sp.compagnia_id,
        sp.volo_num,
        sp.data_ora_partenza_prevista,
        sp.classe_id,
        COUNT(DISTINCT pp.passeggero_id) AS posti_occupati
    FROM SegmentoPrenotazione sp
    JOIN PrenotazioniPasseggeri pp ON sp.prenotazione_id = pp.prenotazione_id
    GROUP BY sp.compagnia_id, sp.volo_num, sp.data_ora_partenza_prevista, sp.classe_id
),

VoliConAereo AS (
    SELECT 
        va.compagnia_id,
        va.volo_num,
        vs.data_ora_partenza_prevista,
        va.aereo_id
    FROM VoliAstratti va
    JOIN VoliSpecifici vs 
      ON va.compagnia_id = vs.compagnia_id 
     AND va.volo_num = vs.volo_num 
     AND vs.data_ora_partenza_prevista = vs.data_ora_partenza_prevista
)

SELECT 
    po.compagnia_id,
    po.volo_num,
    po.data_ora_partenza_prevista,
    po.classe_id,
    po.posti_occupati,
    CASE 
        WHEN po.classe_id = 'J' THEN a.posti_ClasseBusiness
        WHEN po.classe_id = 'Y' THEN a.posti_ClasseEconomy
        ELSE 0
    END AS posti_totali,
    CASE 
        WHEN po.classe_id = 'J' THEN a.posti_ClasseBusiness - po.posti_occupati
        WHEN po.classe_id = 'Y' THEN a.posti_ClasseEconomy - po.posti_occupati
        ELSE 0
    END AS posti_disponibili
FROM PostiOccupatiPerVoloClasse po
JOIN VoliConAereo va ON po.compagnia_id = va.compagnia_id 
                   AND po.volo_num = va.volo_num 
                   AND po.data_ora_partenza_prevista = va.data_ora_partenza_prevista
JOIN Aereo a ON va.aereo_id = a.aereo_id
ORDER BY po.compagnia_id, po.volo_num, po.data_ora_partenza_prevista, po.classe_id;

-- 8 - tutte le prenotazioni con itinerario multi segmento
WITH PrenotazioniMultiSegmento AS (
    SELECT prenotazione_id
    FROM SegmentoPrenotazione
    GROUP BY prenotazione_id
    HAVING COUNT(*) > 1
),

SegmentiConAeroporti AS (
    SELECT 
        sp.prenotazione_id,
        sp.prenotazione_num,
        sp.compagnia_id,
        sp.volo_num,
        sp.data_ora_partenza_prevista,
        a_partenza.codice_IATA AS aeroporto_partenza,
        a_arrivo.codice_IATA AS aeroporto_arrivo
    FROM SegmentoPrenotazione sp
    JOIN VoliSpecifici vs ON sp.compagnia_id = vs.compagnia_id 
                         AND sp.volo_num = vs.volo_num 
                         AND sp.data_ora_partenza_prevista = vs.data_ora_partenza_prevista
    JOIN VoliAstratti va ON sp.compagnia_id = va.compagnia_id AND sp.volo_num = va.volo_num
    JOIN Aeroporti a_partenza ON va.aeroporto_partenza_id = a_partenza.codice_IATA
    JOIN Aeroporti a_arrivo ON va.aeroporto_arrivo_id = a_arrivo.codice_IATA
    WHERE sp.prenotazione_id IN (SELECT prenotazione_id FROM PrenotazioniMultiSegmento)
)
SELECT 
    prenotazione_id,
    -- concateno tutti gli aeroporti di partenza ordinati per prenotazione_num
    -- poi aggiungo l'ultimo aeroporto di arrivo dell'ultimo segmento
    STRING_AGG(aeroporto_partenza, ' -> ') WITHIN GROUP (ORDER BY prenotazione_num) 
        + ' -> ' + MAX(aeroporto_arrivo) AS itinerario
FROM SegmentiConAeroporti
GROUP BY prenotazione_id
ORDER BY prenotazione_id;

-- 9 - focus sulla singola prenotazione, quanti passeggeri appartengono a quella prenotazione e quali sono gli orari nei diversi aeroporti
-- Numero di passeggeri per prenotazione 31
SELECT 
    COUNT(*) AS numero_passeggeri
FROM PrenotazioniPasseggeri
WHERE prenotazione_id = 31;

-- Dettaglio segmenti con orari e aeroporti per prenotazione 31
SELECT 
    sp.prenotazione_num,
    va.aeroporto_partenza_id AS aeroporto_partenza,
    ap.aeroporto_nome AS nome_aeroporto_partenza,
    vs.data_ora_partenza_prevista,
    va.aeroporto_arrivo_id AS aeroporto_arrivo,
    aa.aeroporto_nome AS nome_aeroporto_arrivo,
    vs.data_ora_arrivo_prevista
FROM SegmentoPrenotazione sp
JOIN VoliSpecifici vs ON sp.compagnia_id = vs.compagnia_id 
                     AND sp.volo_num = vs.volo_num 
                     AND sp.data_ora_partenza_prevista = vs.data_ora_partenza_prevista
JOIN VoliAstratti va ON sp.compagnia_id = va.compagnia_id AND sp.volo_num = va.volo_num
JOIN Aeroporti ap ON va.aeroporto_partenza_id = ap.codice_IATA
JOIN Aeroporti aa ON va.aeroporto_arrivo_id = aa.codice_IATA
WHERE sp.prenotazione_id = 31
ORDER BY sp.prenotazione_num;

-- 10 - ricavi per volo
SELECT 
    compagnia_id,
    volo_num,
    data_ora_partenza_prevista,
    SUM(prezzo_segmento) AS totale_incasso
FROM SegmentoPrenotazione
GROUP BY compagnia_id, volo_num, data_ora_partenza_prevista;
