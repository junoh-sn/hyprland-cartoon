#!/usr/bin/env python3
import requests
import json
from pathlib import Path

# --- CONFIG ---
LOCATION = "Paris"          # ex : "Paris", "Beaugency", "auto"
TIMEOUT = 4                 # délai max pour la requête HTTP
CACHE_FILE = Path.home() / ".cache/waybar_weather.json"


def load_cache():
    """Retourne le dernier JSON valide si dispo."""
    try:
        if CACHE_FILE.is_file():
            return json.loads(CACHE_FILE.read_text())
    except Exception:
        pass
    return None


def save_cache(data):
    """Sauvegarde le JSON actuel pour les prochains lancements."""
    try:
        CACHE_FILE.parent.mkdir(parents=True, exist_ok=True)
        CACHE_FILE.write_text(json.dumps(data))
    except Exception:
        pass


def get_weather():
    try:
        url = f"https://wttr.in/{LOCATION}?format=j1"
        r = requests.get(
            url,
            timeout=TIMEOUT,
            headers={"User-Agent": "waybar-weather/1.0"},
        )
        r.raise_for_status()   # lève si code HTTP != 200

        data = r.json()

        current = data["current_condition"][0]
        weather_desc = current["weatherDesc"][0]["value"]
        temp = current["temp_C"]
        feels_like = current["FeelsLikeC"]
        humidity = current["humidity"]
        wind = current["windspeedKmph"]

        # --- Classes selon la condition météo (pour le CSS) ---
        condition_map = {
            "Sunny": "sunny",
            "Clear": "clear",
            "Partly cloudy": "partly-cloudy",
            "Cloudy": "cloudy",
            "Overcast": "overcast",
            "Mist": "mist",
            "Patchy rain possible": "rain",
            "Patchy snow possible": "snow",
            "Patchy sleet possible": "sleet",
            "Patchy freezing drizzle possible": "snow",
            "Thundery outbreaks possible": "thunder",
            "Blowing snow": "snow",
            "Blizzard": "snow",
            "Fog": "fog",
            "Freezing fog": "fog",
            "Patchy light drizzle": "rain",
            "Light drizzle": "rain",
            "Freezing drizzle": "rain",
            "Heavy freezing drizzle": "rain",
            "Patchy light rain": "rain",
            "Light rain": "rain",
            "Moderate rain at times": "rain",
            "Moderate rain": "rain",
            "Heavy rain at times": "rain",
            "Heavy rain": "rain",
            "Light freezing rain": "rain",
            "Moderate or heavy freezing rain": "rain",
            "Light sleet": "sleet",
            "Moderate or heavy sleet": "sleet",
            "Patchy light snow": "snow",
            "Light snow": "snow",
            "Patchy moderate snow": "snow",
            "Moderate snow": "snow",
            "Patchy heavy snow": "snow",
            "Heavy snow": "snow",
            "Ice pellets": "snow",
            "Light rain shower": "rain",
            "Moderate or heavy rain shower": "rain",
            "Torrential rain shower": "rain",
            "Light sleet showers": "sleet",
            "Moderate or heavy sleet showers": "sleet",
            "Light snow showers": "snow",
            "Moderate or heavy snow showers": "snow",
            "Light showers of ice pellets": "snow",
            "Moderate or heavy showers of ice pellets": "snow",
            "Patchy light rain with thunder": "thunder",
            "Moderate or heavy rain with thunder": "thunder",
            "Patchy light snow with thunder": "thunder",
            "Moderate or heavy snow with thunder": "thunder",
        }

        base_class = condition_map.get(weather_desc, "default")

        # --- Classes de température (froid / doux / chaud) ---
        try:
            temp_int = int(temp)
        except ValueError:
            temp_int = 0

        if temp_int <= 5:
            temp_class = "cold"
        elif temp_int >= 25:
            temp_class = "hot"
        else:
            temp_class = "mild"

        css_class = f"{base_class} {temp_class}"

        # --- Icônes Nerd Font météo ---
        icon_map = {
            "Sunny": "󰖙",
            "Clear": "󰖔",
            "Partly cloudy": "󰖕",
            "Cloudy": "󰖐",
            "Overcast": "󰖐",
            "Mist": "󰖑",
            "Patchy rain possible": "󰖗",
            "Patchy snow possible": "󰖘",
            "Patchy sleet possible": "󰖘",
            "Thundery outbreaks possible": "󰖓",
            "Blowing snow": "󰖘",
            "Blizzard": "󰖘",
            "Fog": "󰖑",
            "Freezing fog": "󰖑",
            "Patchy light drizzle": "󰖗",
            "Light drizzle": "󰖗",
            "Freezing drizzle": "󰖗",
            "Heavy freezing drizzle": "󰖗",
            "Patchy light rain": "󰖗",
            "Light rain": "󰖗",
            "Moderate rain at times": "󰖗",
            "Moderate rain": "󰖗",
            "Heavy rain at times": "󰖗",
            "Heavy rain": "󰖗",
            "Light freezing rain": "󰖗",
            "Moderate or heavy freezing rain": "󰖗",
            "Light sleet": "󰖘",
            "Moderate or heavy sleet": "󰖘",
            "Patchy light snow": "󰖘",
            "Light snow": "󰖘",
            "Patchy moderate snow": "󰖘",
            "Moderate snow": "󰖘",
            "Patchy heavy snow": "󰖘",
            "Heavy snow": "󰖘",
            "Ice pellets": "󰖘",
            "Light rain shower": "󰖗",
            "Moderate or heavy rain shower": "󰖗",
            "Torrential rain shower": "󰖗",
            "Light sleet showers": "󰖘",
            "Moderate or heavy sleet showers": "󰖘",
            "Light snow showers": "󰖘",
            "Moderate or heavy snow showers": "󰖘",
            "Light showers of ice pellets": "󰖘",
            "Moderate or heavy showers of ice pellets": "󰖘",
            "Patchy light rain with thunder": "󰖓",
            "Moderate or heavy rain with thunder": "󰖓",
            "Patchy light snow with thunder": "󰖓",
            "Moderate or heavy snow with thunder": "󰖓",
        }

        icon = icon_map.get(weather_desc, "󰖐")

        output = {
            "text": f"{icon} {temp}°C",
            "tooltip": (
                f"<b>{weather_desc}</b>\n\n"
                f" Température: {temp}°C\n"
                f" Ressenti: {feels_like}°C\n"
                f" Humidité: {humidity}%\n"
                f" Vent: {wind} km/h"
            ),
            "class": css_class,
        }

        save_cache(output)
        print(json.dumps(output))

    except Exception as e:
        # En cas d’erreur : on réutilise la dernière valeur plutôt que --°C
        cached = load_cache()
        if cached:
            cached["tooltip"] += f"\n\n[Dernière mise à jour impossible: {e}]"
            print(json.dumps(cached))
        else:
            output = {
                "text": "󰖐 --°C",
                "tooltip": f"Erreur: {e}",
                "class": "default",
            }
            print(json.dumps(output))


if __name__ == "__main__":
    get_weather()

