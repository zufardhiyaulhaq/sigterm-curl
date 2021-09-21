package main

import (
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "hello\n")
}

func main() {
	http.HandleFunc("/hello", hello)

	sigs := make(chan os.Signal, 1)
	done := make(chan bool, 1)

	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		http.ListenAndServe(":9999", nil)
	}()

	go func() {
		sig := <-sigs

		for i := 0; i < 50; i++ {
			resp, err := http.Get("https://www.google.com")

			if err != nil {
				fmt.Println(err)
			}

			fmt.Println(resp.StatusCode)
			time.Sleep(1 * time.Second)

			defer resp.Body.Close()
		}

		fmt.Println(sig)
		done <- true
	}()

	fmt.Println("awaiting signal")
	<-done

	fmt.Println("exiting")
}
