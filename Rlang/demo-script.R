library(ggplot2)
library(getopt)
library(logging)

addHandler(writeToFile, file = "script.log", level = "DEBUG")

# 第三个参数表示这个flag对应的参数形式（0表示flag不接受参数；1表示可接可不接；2表示必须接参数）
spec <- matrix(
  c(
    "DATASET_PATH", "f", 2, "character", "Path of Dataset",
  ),
  byrow = TRUE, ncol = 5
)

command_options <- getopt(spec = spec)

loginfo("program start >>>")

if (is.null(command_options$DATASET_PATH)) {
  stop("DATASET_PATH can not empty")
}

print(command_options$DATASET_PATH)

loginfo("program end <<<")
