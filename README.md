# blog

This repository contains the source code of my [blog](https://nisanthchunduru.github.io)

The blog is built with [Hugo](https://gohugo.io/), a fast static site generator written in Go lang. Blog posts are authored in Notion https://inquisitive-bumper-4db.notion.site/blog_content-0f1b55769779411a95df1ee9b4b070c9?pvs=4 which serves as a CMS (Content Management System).

![image](https://github.com/nisanthchunduru/nisanthchunduru.github.io/assets/1789832/f9a6bf9d-9994-46cf-bdce-baf7d8ef9f04)

![image](https://github.com/nisanthchunduru/nisanthchunduru.github.io/assets/1789832/02804010-47b9-4f57-800c-908272c5868b)

## Installation

First, clone the repository
```
cd ~/Projects/
git clone --recurse-submodules git@github.com:nisanthchunduru/blog.git
```

Install hugo
```
brew install hugo
```

To view the blog in your browser, run
```
hugo server --buildDrafts --watch
```
and visit http://localhost:1313

## Deployment

The blog is deployed from GitHub Actions
