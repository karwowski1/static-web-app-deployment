import requests
import time

# Podstaw swój adres
url = "https://d1vfcl9xxqcpab.cloudfront.net/" 

print(f"Testowanie Rate Limiting dla: {url}")

blocked = False

for i in range(1, 201):
    try:
        response = requests.get(url)
        status = response.status_code
        
        if status == 403:
            print(f"Request #{i}: 🔴 403 Forbidden - WAF ZADZIAŁAŁ!")
            blocked = True
            # Możemy przerwać, bo cel osiągnięty, lub testować dalej
            # break 
        elif status == 200:
            print(f"Request #{i}: 🟢 200 OK")
        else:
            print(f"Request #{i}: 🟡 Inny kod: {status}")
            
    except Exception as e:
        print(f"Błąd przy połączeniu: {e}")

if not blocked:
    print("\n⚠️ Ostrzeżenie: Nie otrzymano 403. Upewnij się, że wysyłasz zapytania szybciej niż limit lub poczekaj chwilę (WAF ma małe opóźnienie).")