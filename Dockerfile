FROM hugomods/hugo:debian-dart-sass-go-0.165.0

WORKDIR /home/conservatory-site

COPY assets/ assets/.
COPY content/ content/.
COPY layouts/ layouts/.
COPY static/ static/.
COPY hugo.toml .

RUN apt-get update && hugo --minify
