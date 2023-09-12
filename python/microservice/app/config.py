import os
from dotenv import load_dotenv

load_dotenv()


"""
Plik konfiguracyjny.
"""

SERVICE_NAME = "python"
"""Nazwa mikroserwisu."""

MS_VERSION = str(os.environ.get("MS_VERSION", "NOT AVAILABLE"))
"""Wersja mikroserwisu."""

SERVICE_PORT = int(os.environ.get("SERVICE_PORT", 80))
"""Port, na którym dostępny jest serwis."""

LOGGING_MODE = str(os.environ.get("LOGGING_MODE", "DEBUG"))
"""Poziom logowania informacji, błędów."""
