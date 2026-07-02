## ---------------------------------------------------------------
## Fictional Office Energy Curve — MAIN branch
## A tongue-in-cheek animated plot of a made-up "energy level"
## across a workday, purely for practicing PRs / merge conflicts.
## ---------------------------------------------------------------

library(ggplot2)
library(gganimate)
library(dplyr)

set.seed(42)

## --- 1. Fake data ------------------------------------------------
person <- "Lulu"
hours <- seq(8, 18, by = 0.25)

energy <- 60 +
  20 * sin((hours - 8) / 10 * pi) -
  10 * (hours > 13 & hours < 14.5) +
  rnorm(length(hours), sd = 4)

energy <- pmin(pmax(energy, 0), 100)

df <- data.frame(hour = hours, energy = energy)

## --- 2. Annotations at key moments --------------------------------
annotations <- data.frame(
  hour = c(9, 13.5, 16),
  energy = c(5, 5, 5),
  label = c(
    "First coffee kicks in",
    "Post-lunch slowdown",
    "Second wind, mostly caffeine"
  )
)

## --- 3. Colour palette ---------------------------------------------
low_colour <- "#2980B9"
high_colour <- "#E74C3C"

## --- 4. Plot ---------------------------------------------------------
p <- ggplot(df, aes(x = hour, y = energy)) +
  geom_line(aes(colour = energy), linewidth = 1) +
  geom_point(aes(colour = energy), size = 2) +
  scale_colour_gradient(low = low_colour, high = high_colour, name = "Energy") +
  geom_label(
    data = annotations,
    aes(x = hour, y = energy, label = label, group = label),
    size = 3.5,
    colour = "black",
    fill = "white",
    label.size = 0.3,
    inherit.aes = FALSE
  ) +
  labs(
    title = paste("How much does", person, "have over the day", sep = " "),
    subtitle = "A completely unscientific simulation",
    x = "Hour of day",
    y = "Energy (%)"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid = element_blank(),
    axis.line = element_line(colour = "grey20"),
    axis.ticks = element_line(colour = "grey20")
  )

## --- 5. Animate --------------------------------------------------
anim <- p +
  transition_reveal(hour) +
  enter_appear() +
  exit_disappear()

animate(
  anim,
  nframes = 100,
  fps = 10,
  width = 700,
  height = 450,
  end_pause = 15
)

# anim_save("energy_curve_main.gif")