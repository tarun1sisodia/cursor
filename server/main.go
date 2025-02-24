package main

import (
    "log"
    "net/http"

    "github.com/gin-gonic/gin"
    "github.com/gin-contrib/cors"
)

func main() {
    router := gin.Default()

    // Enable CORS
    config := cors.DefaultConfig()
    config.AllowOrigins = []string{"*"} // Configure according to your needs
    router.Use(cors.New(config))

    // Routes
    api := router.Group("/api")
    {
        // Auth routes
        auth := api.Group("/auth")
        {
            auth.POST("/register", handleRegister)
            auth.POST("/verify-phone", handleVerifyPhone)
            auth.POST("/confirm-otp", handleConfirmOTP)
        }

        // Protected routes (require authentication)
        protected := api.Group("/protected")
        protected.Use(authMiddleware())
        {
            protected.GET("/user-profile", handleGetUserProfile)
            // Add more protected routes as needed
        }
    }

    log.Fatal(router.Run(":8080"))
}

func handleRegister(c *gin.Context) {
    var input struct {
        Username string `json:"username" binding:"required"`
        Email    string `json:"email" binding:"required,email"`
        Password string `json:"password" binding:"required"`
        Phone    string `json:"phone" binding:"required"`
    }

    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // TODO: Implement registration logic
    c.JSON(http.StatusOK, gin.H{"message": "Registration successful"})
}

func handleVerifyPhone(c *gin.Context) {
    var input struct {
        Phone string `json:"phone" binding:"required"`
    }

    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // TODO: Implement phone verification logic
    c.JSON(http.StatusOK, gin.H{"message": "Verification code sent"})
}

func handleConfirmOTP(c *gin.Context) {
    var input struct {
        Phone string `json:"phone" binding:"required"`
        OTP   string `json:"otp" binding:"required"`
    }

    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // TODO: Implement OTP confirmation logic
    c.JSON(http.StatusOK, gin.H{"message": "OTP verified successfully"})
}

func authMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        // TODO: Implement authentication middleware
        c.Next()
    }
} 