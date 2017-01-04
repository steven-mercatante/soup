# Hale and Hearty Soup List

A simple exercise in scraping [Hale and Hearty](https://www.haleandhearty.com/) for a list of their locations and soups.

## Requirements

- Elixir v1.3+
- Erlang v18+

## Usage

Run `mix escript.build` to create a `soup` executable, then run `./soup`.

When using for the first time, you'll be prompted to select a location whose soup menu you want to view. 
Subsequent calls to `./soup` will retrieve the list of soups from this location. 
You can change the default location by calling `./soup --locations`.