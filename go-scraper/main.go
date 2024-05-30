package main

import (
	"fmt"
)

func main() {
	// Get a greeting message and print it.
	var website string = "https://github.com/opentofu/opentofu/releases/latest"

	github_version := scraper.get_github_version(scraper.get_webpage(website))
	fmt.Println(github_version)
}
