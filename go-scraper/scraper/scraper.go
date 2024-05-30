package scraper

import (
	"bytes"
	"fmt"
	"io"
	"net/http"
	"regexp"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

func get_webpage(webpage string) string {

	request, err := http.Get(webpage)
	if err != nil {
		panic(err)
	}

	htmlpage, err := io.ReadAll(request.Body)
	if err != nil {
		panic(err)
	}

	return string(htmlpage)
}

func get_github_version(htmlonpage string) string {

	//var htmlonpage string = get_webpage(website)

	//TEST
	//var htmlpage string = "mick <title> T \t Release v1.12342.3"
	//fmt.Println(htmlpage)

	if !strings.Contains(string(htmlonpage), "<title>") {
		panic("html page does not contain title")
	}

	reader := bytes.NewReader([]byte(htmlonpage))
	doc, err := goquery.NewDocumentFromReader(reader)
	if err != nil {
		panic(err)
	}
	text := doc.Find("title").Text()

	if !strings.Contains(text, "Release ") {
		panic("<title> does not contain Release version")
	}

	//check to make sure we got something on the line that contains the Release
	if len(text) < 3 {
		fmt.Println("string is not long enough to have a release version")
	}
	//fmt.Println(text)

	//starts with a digit, only digit and '.' is allowed
	re := regexp.MustCompile("[0-9.]+")
	version := re.FindAllString(text, -1)
	//fmt.Println(version)
	var clean_version string = strings.TrimSpace(strings.Join(version, ""))
	fmt.Println("Version number: ", clean_version)

	return clean_version
}
