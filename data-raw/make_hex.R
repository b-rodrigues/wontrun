#https://www.stockio.com/free-icon/healthy-icons-crutch
library(magick)
#remotes::install_github("dmi3kno/bunny")
library(bunny)

logo_leg <- image_read_svg("data-raw/broken-leg.svg", width = 800)

br_col <- "#313D5A"
br2_col <- "#C0B7CC"
bg_col <- "#FFFBFC"
bk_col <- "#00100B"

wr_hex <- image_canvas_hex(fill_color = bg_col, border_color = br_col, border_size = 1) %>%
  image_composite(image_colorize(logo_leg, 100, br2_col) , gravity = "center", offset = "-20-150") %>%
  image_composite(logo_leg, gravity = "center", offset = "-30-160") %>%
  image_annotate("wontrun", gravity = "center", location = "+8+408",
                 size=230, font="Aller", color = br2_col, weight = 400) %>%
  image_annotate("wontrun", gravity = "center", location = "+0+400",
                 size=230, font="Aller", color = bk_col, weight = 400) %>%
  image_composite(image_canvas_hexborder(border_color = br2_col, border_size = 13), gravity = "center")   %>%
  image_composite(image_canvas_hexborder(border_color = br_col, border_size = 8), gravity = "center")   %>%
  image_scale("50%")

wr_hex %>%
  image_scale("1200x1200") %>%
  image_write("data-raw/wr_hex.png", density = 600)

wr_hex %>%
  image_scale("200x200") %>%
  image_write("man/figures/logo.png", density = 600)

wr_hex_gh <- wr_hex %>%
  image_scale("400x400")


gh_logo <- bunny::github %>%
  image_scale("40x40")

wr_ghcard <- image_canvas_ghcard(fill_color = bg_col) %>%
  image_composite(wr_hex_gh, gravity = "East", offset = "+100+0") %>%
  image_annotate("Give your old examples", gravity = "West", location = "+60-80",
                 color=br_col, size=55, font="Volkhov", weight = 500) %>%
  image_annotate("a second chance", gravity = "West", location = "+60-10",
                 color=br_col, size=55, font="Volkhov", weight = 500) %>%
  image_compose(gh_logo, gravity="West", offset = "+60+70") %>%
  image_annotate("b-rodrigues/wontrun", gravity="West",
                 location="+110+70", size=38, font="Ubuntu Mono") %>%
  image_border_ghcard(bg_col) %>%
  image_scale("50%")

wr_ghcard

wr_ghcard %>%
  image_write("data-raw/wr_ghcard.png", density = 600)
