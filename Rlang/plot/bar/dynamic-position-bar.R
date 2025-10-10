library(ggplot2)
library(getopt)
library(logging)

addHandler(writeToFile, file = "script.log", level = "DEBUG")

# 第三个参数表示这个flag对应的参数形式（0表示flag不接受参数；1表示可接可不接；2表示必须接参数）
spec <- matrix(
  c(
    "DATASET_PATH", "f", 2, "character", "Path of Dataset",
    "AES_X", "ax", 2, "character", "Aes_x",
    "AES_Y", "ay", 2, "character", "Aes_y",
    "AES_FILL", "af", 2, "character", "Aes_fill",
    "GEOM_BAR_STAT", "gbs", 1, "character", "stat of geom_bar",
    "GEOM_BAR_POSITION", "gbp", 1, "character", "position of geom_bar",
    "LABS_TITLE", "lt", 1, "character", "Labs_title",
    "LABS_X", "lx", 1, "character", "Labs_x",
    "LABS_Y", "ly", 1, "character", "Labs_y",
    "THEME_AXIS_TEXT_X_ANGLE", "tatxa", 1, "double", "axis.text.x angle",
    "THEME_AXIS_TEXT_X_HJUST", "tatxh", 1, "double", "axis.text.x hjust",
    "THEME_AXIS_TEXT_X_SIZE", "tatxs", 1, "double", "axis.text.x size",
    "COORD_FLIP_FLAG", "cff", 1, "logical", "coord_flip",
    "SCALE_FILL_MANUAL_VALUES", "SFMC", 1, "character", "scale_fill_manual values",
    "PLOT_SAVE_PATH", "psp", 1, "character", "Save Path of Plot",
    "PLOT_SAVE_NAME", "psn", 1, "character", "Save Name of Plot",
    "PLOT_SAVE_WIDTH", "psw", 1, "double", "Save Width of Plot",
    "PLOT_SAVE_HEIGHT", "psh", 1, "double", "Save Height of Plot",
    "PLOT_SAVE_DPI", "dpi", 1, "double", "Save Dpi of Plot",
    "help", "h", 0, "logical", "This is Help!"
  ),
  byrow = TRUE, ncol = 5
)

command_options <- getopt(spec = spec)

loginfo("program start >>>")

if (is.null(command_options$DATASET_PATH)) {
  stop("DATASET_PATH can not empty")
}

if (is.null(command_options$AES_X)) {
  stop("AES_X can not empty")
}

if (is.null(command_options$AES_FILL)) {
  stop("AES_FILL can not empty")
}

dataset <- readRDS(command_options$DATASET_PATH)

geom_bar_position <- if (!is.null(command_options$GEOM_BAR_POSITION)) command_options$GEOM_BAR_POSITION else "stack"
geom_bar_stat <- if (!is.null(command_options$GEOM_BAR_STAT)) command_options$GEOM_BAR_STAT else "count"

coord_flip_flag <- if (!is.null(command_options$COORD_FLIP_FLAG)) command_options$COORD_FLIP_FLAG else FALSE

plot <- ggplot(dataset, aes(x = !!sym(command_options$AES_X), fill = !!sym(command_options$AES_FILL))) +
  geom_bar(position = geom_bar_position) +
  labs(
    title = if (!is.null(command_options$LABS_TITLE)) command_options$LABS_TITLE else "Filled Bar chart",
    x = if (!is.null(command_options$LABS_X)) command_options$LABS_X else "X",
    y = if (!is.null(command_options$LABS_Y)) command_options$LABS_Y else "Y"
  )

theme_axis_text_x_angle <- if (!is.null(command_options$THEME_AXIS_TEXT_X_ANGLE)) command_options$THEME_AXIS_TEXT_X_ANGLE else NULL
theme_axis_text_x_hjust <- if (!is.null(command_options$THEME_AXIS_TEXT_X_HJUST)) command_options$THEME_AXIS_TEXT_X_HJUST else NULL
theme_axis_text_x_size <- if (!is.null(command_options$THEME_AXIS_TEXT_X_SIZE)) command_options$THEME_AXIS_TEXT_X_SIZE else NULL

if (!is.null(theme_axis_text_x_angle) || !is.null(theme_axis_text_x_hjust) || !is.null(theme_axis_text_x_size)) {
  plot <- plot + theme(axis.text.x = element_text(angle = theme_axis_text_x_angle, hjust = theme_axis_text_x_hjust, size = theme_axis_text_x_size))
}

if (coord_flip_flag) {
  plot <- plot + coord_flip()
}

plot_save_path <- if (!is.null(command_options$PLOT_SAVE_PATH)) command_options$PLOT_SAVE_PATH else "."

scale_fill_manual_values <- if (!is.null(command_options$SCALE_FILL_MANUAL_VALUES)) strsplit(command_options$SCALE_FILL_MANUAL_VALUES, ",")[[1]] else NULL
if (!is.null(scale_fill_manual_values)) {
  plot <- plot + scale_fill_manual(values = scale_fill_manual_values)
}

plot_save_path <- if (!is.null(command_options$PLOT_SAVE_PATH)) command_options$PLOT_SAVE_PATH else "."
plot_save_name <- if (!is.null(command_options$PLOT_SAVE_NAME)) command_options$PLOT_SAVE_NAME else "Rplots.pdf"
plot_save_with <- if (!is.null(command_options$PLOT_SAVE_WIDTH)) command_options$PLOT_SAVE_WIDTH else 7
plot_save_height <- if (!is.null(command_options$PLOT_SAVE_HEIGHT)) command_options$PLOT_SAVE_HEIGHT else 7
plot_save_dpi <- if (!is.null(command_options$PLOT_SAVE_DPI)) command_options$PLOT_SAVE_DPI else 300

ggsave(plot_save_name,
  plot = plot,
  path = plot_save_path,
  width = plot_save_with, height = plot_save_height,
  dpi = plot_save_dpi
)

loginfo("program end <<<")
