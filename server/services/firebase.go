package services

import (
	"context"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	"google.golang.org/api/option"
)

type FirebaseService struct {
	Client *auth.Client
}

func NewFirebaseService(credentialsFile string) (*FirebaseService, error) {
	opt := option.WithCredentialsFile(credentialsFile)
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		return nil, err
	}

	client, err := app.Auth(context.Background())
	if err != nil {
		return nil, err
	}

	return &FirebaseService{Client: client}, nil
}

func (fs *FirebaseService) VerifyIDToken(idToken string) (*auth.Token, error) {
	return fs.Client.VerifyIDToken(context.Background(), idToken)
} 