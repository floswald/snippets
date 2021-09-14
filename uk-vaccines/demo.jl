using ExcelFiles, DataFrames, CairoMakie
using Downloads, Pipe

url = "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fdeathsbyvaccinationstatusengland%2fdeathsoccurringbetween2januaryand2july2021/datatable10092021145650.xlsx"

d = @pipe Downloads.download(url, "ons.xlsx") |> 
          load(_,"Table 1!A5:D11") |> 
          DataFrame

dd = subset(d, 
     "Vaccination status" => x -> occursin.(r"Unvaccinated|Deaths 21 days or more after sec", x))

rename!(x -> replace(x, " " => "_"), dd)

fig = barplot(dd[!,:Percent_of_all_deaths],
              color = [:red, :green],
              axis = (xticks = (1:2, ["Not" , "Vaccinated"]), 
                      title = "% of All Deaths in England by Vaccination Status\nJan 2021-Jul 2021",
                      ylabel = "%"),
              bar_labels = :y,
              label_formatter = x-> "$(x)%",
              label_offset = 10,
              flip_labels_at = 10
)

save("ons-deaths.png", fig)