package config

import (
    "os"

    "github.com/joho/godotenv"
)

type Config struct {
    DBHost     string
    DBUser     string
    DBPassword string
    DBName     string
    JWTSecret  string
    FirebaseConfig string
}

func LoadConfig() (*Config, error) {
    err := godotenv.Load()
    if err != nil {
        return nil, err
    }

    return &Config{
        DBHost:     os.Getenv("DB_HOST"),
        DBUser:     os.Getenv("DB_USER"),
        DBPassword: os.Getenv("DB_PASSWORD"),
        DBName:     os.Getenv("DB_NAME"),
        JWTSecret:  os.Getenv("JWT_SECRET"),
        FirebaseConfig: os.Getenv("FIREBASE_CONFIG"),
    }, nil
} 