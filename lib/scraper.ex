defmodule Scraper do

    @doc """
    Fetch a list of all of the Hale and Hearty locations.
    """
    def get_locations() do
        case HTTPoison.get("https://www.haleandhearty.com/locations/") do
            {:ok, response} ->
                case response.status_code do
                    200 ->
                        locations = 
                            response.body
                            |> Floki.find(".location-card")
                            |> Enum.map(&extract_location_name_and_id/1)
                            |> Enum.sort(&(&1.name < &2.name))

                        {:ok, locations}   

                    _ -> :error
                end
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

        case HTTPoison.get(url) do
            {:ok, response} -> 
                case response.status_code do
                    200 ->
                        soups =
                            response.body
                            # Floki uses the CSS descendant selector for the below find() call
                            |> Floki.find("div.category.soups p.menu-item__name")
                            |> Enum.map(fn({_, _, [soup]}) -> soup end)

                        {:ok, soups}

                    _ -> :error
                end

            _ -> :error
        end
    end    

end