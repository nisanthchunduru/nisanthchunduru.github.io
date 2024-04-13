# blog

This repository contains the source code of my [blog](https://nisanthchunduru.github.io)

## Installation & Usage

The blog is built with [Hugo](https://gohugo.io/), a fast static site generator written in the Go programming language

First, clone the repository
```
cd ~/Projects/
git clone git@github.com:nisanthchunduru/blog.git
```

Install hugo
```
brew install hugo
```

To view the blog in your browser, run
```
hugo server --buildDrafts --watch
```
and visit http://localhost:1313/

To publish the blog after adding a blog post, run
```
bin/deploy
```

## Why

Why build a custom blog?

Its mostly an experiment to learn CSS.
