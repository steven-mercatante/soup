defmodule Scraper do

    @doc """
    Fetch a list of all of the Hale and Hearty locations.
    """
    def get_locations() do
        with {:ok, response} <- HTTPoison.get("https://www.haleandhearty.com/locations/"),
             200 <- response.status_code
        do
            locations =
                response.body
                |> Floki.find(".location-card")
                |> Enum.map(&extract_location_name_and_id/1)
                |> Enum.sort(&(&1.name < &2.name))

            {:ok, locations}
        else
            _ -> :error
        end
    end

    defp extract_location_name_and_id({_tag, attrs, children}) do
        {_, _, [name]} = 
            Floki.raw_html(children)
            |> Floki.find(".location-card__name")
            |> hd()

        attrs = Enum.into(attrs, %{})

        %{id: attrs["id"], name: name}
    end

    def get_soups(location_id) do
        url = "https://www.haleandhearty.com/menu/?location=#{location_id}"

        with {:ok, response} <- HTTPoison.get(url),
             200 <- response.status_code
        do
            soups =
                response.body
                # Floki uses the CSS descendant selector for the below find() call
                |> Floki.find("div.category.soups p.menu-item__name")
                |> Enum.map(fn({_, _, [soup]}) -> soup end)

            {:ok, soups}
        else
            _ -> :error
        end
    end    

end