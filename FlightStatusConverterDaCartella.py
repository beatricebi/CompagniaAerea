#esempio di uno degli script py usati per convertire i json delle web api

import json
import pandas as pd
import os

# percorso cartella
folder_path = r"C:\Users\Beatrice\Desktop\TESI\CompagniaAerea\FlightStatus_CSV\07JUL25"
output_csv = "FlightStatus_07JUL25.csv"

# percorso per i record
all_records = []

# Loop di tutti i json nella cartella
for filename in os.listdir(folder_path):
    if filename.endswith(".json"):
        file_path = os.path.join(folder_path, filename)
        with open(file_path, "r") as f:
            data = json.load(f)
        
        flights = data.get("FlightStatusResource", {}).get("Flights", {}).get("Flight", [])
        
        for flight in flights:
            departure = flight.get("Departure", {})
            arrival = flight.get("Arrival", {})
            
            record = {
                "Departure_Airport": departure.get("AirportCode"),
                "Departure_Scheduled_Local": departure.get("ScheduledTimeLocal", {}).get("DateTime"),
                "Departure_Scheduled_UTC": departure.get("ScheduledTimeUTC", {}).get("DateTime"),
                "Departure_Actual_Local": departure.get("ActualTimeLocal", {}).get("DateTime"),
                "Departure_Actual_UTC": departure.get("ActualTimeUTC", {}).get("DateTime"),

                "Arrival_Airport": arrival.get("AirportCode"),
                "Arrival_Scheduled_Local": arrival.get("ScheduledTimeLocal", {}).get("DateTime"),
                "Arrival_Scheduled_UTC": arrival.get("ScheduledTimeUTC", {}).get("DateTime"),
                "Arrival_Actual_Local": arrival.get("ActualTimeLocal", {}).get("DateTime"),
                "Arrival_Actual_UTC": arrival.get("ActualTimeUTC", {}).get("DateTime"),

                "FlightStatus_Code": flight.get("FlightStatus", {}).get("Code"),
                "FlightStatus_Definition": flight.get("FlightStatus", {}).get("Definition"),

                "AirlineID": flight.get("MarketingCarrier", {}).get("AirlineID"),
                "FlightNumber": flight.get("MarketingCarrier", {}).get("FlightNumber"),
                "AircraftCode": flight.get("Equipment", {}).get("AircraftCode"),
                "AircraftRegistration": flight.get("Equipment", {}).get("AircraftRegistration"),

                "Source_File": filename  # Optional: track which file it came from
            }
            
            all_records.append(record)

# creazione DataFrame
df = pd.DataFrame(all_records)

# salva in csv nella stessa cartella
output_path = os.path.join(folder_path, output_csv)
df.to_csv(output_path, index=False)

# print se andato a buon fine
print(f" Unito {len(all_records)} records in: {output_path}")
print(df.head())
