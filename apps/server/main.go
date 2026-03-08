package main

import (
	"context"
	"log"
	"net/http"
	"time"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humago"
)

type GreetingOutput struct {
	Body struct {
		Message string `json:"message"`
	}
}

func main() {
	mux := http.NewServeMux()

	api := humago.New(mux, huma.DefaultConfig("My Standard API", "1.0.0"))

	huma.Register(api, huma.Operation{
		Method: http.MethodGet,
		Path:   "/greeting/{name}",
	}, func(ctx context.Context, input *struct{ Name string `path:"name"` }) (*GreetingOutput, error) {
		resp := &GreetingOutput{}
		resp.Body.Message = "Hello, " + input.Name
		return resp, nil
	})

	server := &http.Server{
		Addr:         ":8888",
		Handler:      mux,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	log.Fatal(server.ListenAndServe())
}
