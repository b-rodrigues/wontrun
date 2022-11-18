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

# Alternative texts
# - Code longevity. Tested.
# - Vintage code clinic
# - Veteran code gym
# - New dog, old tricks
# - How’s your old code doing?
# - Physiotherapy for old code


wr_ghcard <- image_canvas_ghcard(fill_color = bg_col) %>%
  image_composite(wr_hex_gh, gravity = "East", offset = "+100+0") %>%
  image_annotate("Code longevity.", gravity = "West", location = "+100-50",
                 color=br_col, size=60, font="Aller", weight = 500) %>%
  image_annotate("Tested.", gravity = "West", location = "+100+20",
                 color=br_col, size=60, font="Aller", weight = 500) %>%
  image_compose(gh_logo, gravity="West", offset = "+100+100") %>%
  image_annotate("b-rodrigues/wontrun", gravity="West",
                 location="+150+100", size=38, font="Ubuntu Mono") %>%
  image_border_ghcard(bg_col) %>%
  image_scale("50%")

wr_ghcard

wr_ghcard %>%
  image_write("data-raw/wr_ghcard.png", density = 600)
