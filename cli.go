package main

import (
	"log"
	"os"

	"github.com/mitchellh/cli"
)

/** foo サブコマンド用の実装 **/
type Foo struct{}

func (f *Foo) Help() string {
	return "app foo"
}

func (f *Foo) Run(args []string) int {
	log.Println("Foo!")
	return 0
}

func (f *Foo) Synopsis() string {
	return "Print \"Foo!\""
}

/** bar サブコマンド用の実装 **/
type Bar struct{}

func (b *Bar) Help() string {
	return "app bar"
}

func (b *Bar) Run(args []string) int {
	log.Println("Bar!")
	return 0
}

func (b *Bar) Synopsis() string {
	return "Print \"Bar!\""
}

func main() {
	// コマンドの名前とバージョンを指定
	c := cli.NewCLI("app", "1.0.0")

	// サブコマンドの引数を指定
	c.Args = os.Args[1:]

	// サブコマンド文字列 と コマンド実装の対応付け
	c.Commands = map[string]cli.CommandFactory{
		"foo": func() (cli.Command, error) {
			return &Foo{}, nil
		},
		"bar": func() (cli.Command, error) {
			return &Bar{}, nil
		},
	}

	// コマンド実行
	exitStatus, err := c.Run()
	if err != nil {
		log.Println(err)
	}

	os.Exit(exitStatus)
}
