# =========================================================
# .Rprofile — normative_van | DAILY TOOLKIT
# macOS / RStudio / Quarto / Git
# =========================================================

options(
  repos = c(CRAN = "https://cloud.r-project.org"),
  encoding = "UTF-8",
  scipen = 999,
  max.print = 1000,
  width = 120
)

# ==== PROJECT ====

.project_name <- "normative_van"
.project_qmd  <- "normative_van_11.qmd"

norm_path <- function(path = ".") {
  normalizePath(path.expand(path), winslash = "/", mustWork = FALSE)
}

proj_root <- function() {
  if (requireNamespace("here", quietly = TRUE)) {
    x <- tryCatch(here::here(), error = function(e) NULL)
    if (!is.null(x) && dir.exists(x)) return(norm_path(x))
  }
  norm_path(getwd())
}

proj_rel <- function(path) {
  root <- paste0(norm_path(proj_root()), "/")
  x <- norm_path(path)
  out <- ifelse(startsWith(x, root), substring(x, nchar(root) + 1L), x)
  out[x == sub("/$", "", root)] <- "."
  out
}

fmt_size <- function(x) {
  if (!length(x)) return(character(0))
  vapply(x, function(v) {
    if (is.na(v)) return(NA_character_)
    if (v < 1024) return(sprintf("%d B", as.integer(v)))
    if (v < 1024^2) return(sprintf("%.1f KB", v / 1024))
    if (v < 1024^3) return(sprintf("%.1f MB", v / 1024^2))
    sprintf("%.2f GB", v / 1024^3)
  }, character(1))
}

# ==== HỒI HƯỚNG ====

niem_phat <- function() {
  cat("✨✦ Nam Mô A Di Đà Phật ✦✨\n")
  invisible(NULL)
}

hoi_huong <- function() {
  cat("🌸 Nguyện đem công đức này hồi hướng khắp tất cả.\n")
  cat("✨ Nam Mô A Di Đà Phật ✨\n")
  invisible(NULL)
}

hh <- hoi_huong
np <- niem_phat

# ==== DIRECTORY ====

wd <- function() {
  x <- norm_path(getwd())
  cat("📁", x, "\n")
  invisible(x)
}

proj <- function() {
  x <- proj_root()
  cat("🏠", x, "\n")
  invisible(x)
}

pj <- function() {
  x <- proj_root()
  setwd(x)
  cat("🏠", x, "\n")
  invisible(x)
}

cd <- function(path = "~") {
  path <- path.expand(path)
  if (!dir.exists(path)) {
    cat("❌ Không thấy thư mục:", path, "\n")
    return(invisible(NULL))
  }
  setwd(path)
  wd()
}

up <- function(n = 1) {
  n <- suppressWarnings(as.integer(n))
  if (is.na(n) || n < 1) n <- 1L
  x <- getwd()
  for (i in seq_len(n)) x <- dirname(x)
  cd(x)
}

back <- function() up(1)

# ==== OPEN / NUMBERED FILES ====

.last_files <- character(0)

open_file <- function(path = ".") {
  path <- path.expand(path)
  
  if (!file.exists(path) && !dir.exists(path)) {
    cat("❌ Không tồn tại:", path, "\n")
    return(invisible(NULL))
  }
  
  path <- normalizePath(path, winslash = "/", mustWork = TRUE)
  
  if (Sys.info()[["sysname"]] == "Darwin") {
    system(paste("/usr/bin/open", shQuote(path)))
  } else if (.Platform$OS.type == "windows") {
    shell.exec(path)
  } else {
    system(paste("xdg-open", shQuote(path)))
  }
  
  invisible(path)
}

o <- function(x) {
  if (is.numeric(x)) {
    i <- suppressWarnings(as.integer(x[1]))
    if (is.na(i) || i < 1 || i > length(.last_files)) {
      cat("❌ Số không hợp lệ. Chạy tree(), recent(), ff() hoặc f() trước.\n")
      return(invisible(NULL))
    }
    return(open_file(.last_files[i]))
  }
  open_file(x)
}

fopen <- open_file
ppt   <- open_file
oppt  <- open_file
opptx <- open_file
opdf  <- open_file
odoc  <- open_file
word  <- open_file
excel <- open_file

get_num_file <- function(i) {
  i <- suppressWarnings(as.integer(i[1]))
  if (is.na(i) || i < 1 || i > length(.last_files)) {
    cat("❌ Số không hợp lệ. Chạy tree(), recent(), ff() hoặc f() trước.\n")
    return(NULL)
  }
  normalizePath(.last_files[i], winslash = "/", mustWork = TRUE)
}

vf <- function(i) {
  f <- get_num_file(i)
  if (is.null(f)) return(invisible(NULL))
  system(paste("/usr/bin/open -R", shQuote(f)))
  invisible(f)
}

commander_one <- function(i) {
  f <- get_num_file(i)
  if (is.null(f)) return(invisible(NULL))
  
  app <- "/Applications/Commander One.app"
  if (!dir.exists(app)) {
    cat("❌ Không tìm thấy /Applications/Commander One.app\n")
    return(invisible(NULL))
  }
  
  system(paste(
    "/usr/bin/open -a",
    shQuote("Commander One"),
    shQuote(dirname(f))
  ))
  
  cat("📂", proj_rel(f), "\n")
  invisible(f)
}

vc <- commander_one
vd <- commander_one

v <- function(i) {
  vf(i)
  commander_one(i)
  invisible(NULL)
}

reveal <- function(path = ".") {
  path <- path.expand(path)
  if (!file.exists(path) && !dir.exists(path)) {
    cat("❌ Không tồn tại:", path, "\n")
    return(invisible(NULL))
  }
  if (dir.exists(path)) open_file(path) else system(paste("/usr/bin/open -R", shQuote(norm_path(path))))
  invisible(path)
}

# ==== FILE LIST / SEARCH BY NAME ====

file_table <- function(path = ".", recursive = FALSE) {
  x <- list.files(path, full.names = TRUE, recursive = recursive, no.. = TRUE)
  if (!length(x)) return(data.frame())
  
  info <- file.info(x)
  
  data.frame(
    name = basename(x),
    type = ifelse(info$isdir, "DIR", toupper(tools::file_ext(x))),
    size = ifelse(info$isdir, "", fmt_size(info$size)),
    mtime = info$mtime,
    path = norm_path(x),
    stringsAsFactors = FALSE
  )
}

clean_files <- function(df) {
  if (!nrow(df)) return(df)
  df[!grepl("^~\\$", df$name), , drop = FALSE]
}

print_files_compact <- function(df, show_size = TRUE) {
  if (!nrow(df)) return(invisible(df))
  
  rel <- proj_rel(df$path)
  
  for (i in seq_len(nrow(df))) {
    if (show_size) {
      cat(sprintf("%3d. %-9s %s\n", i, df$size[i], rel[i]))
    } else {
      cat(sprintf("%3d. %s\n", i, rel[i]))
    }
  }
  
  invisible(df)
}

lsd <- function(path = ".", recursive = FALSE) {
  df <- clean_files(file_table(path, recursive))
  
  if (!nrow(df)) {
    cat("📭 Trống\n")
    return(invisible(df))
  }
  
  for (i in seq_len(nrow(df))) {
    icon <- if (df$type[i] == "DIR") "📁" else "📄"
    cat(sprintf("%s %-8s %s\n", icon, df$size[i], proj_rel(df$path[i])))
  }
  
  invisible(df)
}

lsf <- function(path = ".", ext = NULL, recursive = FALSE) {
  df <- clean_files(file_table(path, recursive))
  if (!nrow(df)) return(invisible(df))
  
  df <- df[df$type != "DIR", , drop = FALSE]
  
  if (!is.null(ext)) {
    ext <- toupper(gsub("^\\.", "", ext))
    df <- df[df$type %in% ext, , drop = FALSE]
  }
  
  .last_files <<- df$path
  print_files_compact(df)
  invisible(df)
}

recent <- function(path = ".", n = 10, recursive = TRUE) {
  df <- clean_files(file_table(path, recursive))
  
  if (!nrow(df)) {
    cat("📭 Trống\n")
    return(invisible(df))
  }
  
  df <- df[df$type != "DIR", , drop = FALSE]
  df <- df[order(df$mtime, decreasing = TRUE), , drop = FALSE]
  df <- head(df, n)
  
  .last_files <<- df$path
  
  print_files_compact(df)
  cat("→ o(1), o(2), ...\n")
  
  invisible(df)
}

ff <- function(pattern, path = ".", n = 30) {
  df <- clean_files(file_table(path, recursive = TRUE))
  
  if (!nrow(df)) return(invisible(df))
  
  df <- df[
    df$type != "DIR" & grepl(pattern, df$name, ignore.case = TRUE),
    ,
    drop = FALSE
  ]
  
  df <- head(df, n)
  
  if (!nrow(df)) {
    cat("❌ Không tìm thấy tên file:", pattern, "\n")
    return(invisible(df))
  }
  
  .last_files <<- df$path
  
  print_files_compact(df)
  cat("→ o(1), o(2), ...\n")
  
  invisible(df)
}

lsr   <- function(path = ".", recursive = TRUE) lsf(path, "R", recursive)
lsq   <- function(path = ".", recursive = TRUE) lsf(path, "qmd", recursive)
lsdoc <- function(path = ".", recursive = TRUE) lsf(path, c("docx","pdf","ppt","pptx","xlsx","xls"), recursive)
lsppt <- function(path = ".", recursive = TRUE) lsf(path, c("ppt","pptx"), recursive)
lspdf <- function(path = ".", recursive = TRUE) lsf(path, "pdf", recursive)

# ==== TREE ====

tree <- function(path = ".", level = 2) {
  root <- normalizePath(path, winslash = "/", mustWork = TRUE)
  files_found <- character(0)
  counter <- 0L
  
  walk <- function(current, depth, prefix = "") {
    if (depth < 0) return(invisible(NULL))
    
    items <- list.files(current, full.names = TRUE, no.. = TRUE)
    items <- items[!grepl("^~\\$", basename(items))]
    if (!length(items)) return(invisible(NULL))
    
    items <- items[order(!dir.exists(items), tolower(basename(items)))]
    
    for (j in seq_along(items)) {
      item <- items[j]
      last <- j == length(items)
      conn <- if (last) "└── " else "├── "
      next_prefix <- paste0(prefix, if (last) "    " else "│   ")
      
      if (dir.exists(item)) {
        cat(prefix, conn, "📁 ", basename(item), "/\n", sep = "")
        if (depth > 0) walk(item, depth - 1, next_prefix)
      } else {
        counter <<- counter + 1L
        files_found <<- c(files_found, item)
        cat(prefix, conn, sprintf("[%d] ", counter), basename(item), "\n", sep = "")
      }
    }
  }
  
  cat(basename(root), "/\n", sep = "")
  walk(root, level)
  
  .last_files <<- files_found
  
  cat("\n→ mở: o(1), o(2), ...\n")
  invisible(files_found)
}

# ==== READ TEXT FILE ====

readf <- function(path, n = Inf) {
  path <- path.expand(path)
  
  if (!file.exists(path)) {
    cat("❌ Không thấy file:", path, "\n")
    return(invisible(NULL))
  }
  
  ext <- tolower(tools::file_ext(path))
  text_ext <- c(
    "txt","md","r","rmd","qmd","csv","tsv",
    "json","yaml","yml","log","html","htm","bib","csl"
  )
  
  if (!ext %in% text_ext) return(open_file(path))
  
  x <- readLines(path, warn = FALSE, encoding = "UTF-8")
  if (is.finite(n)) x <- head(x, n)
  
  cat(paste(x, collapse = "\n"), "\n")
  invisible(x)
}

headf <- function(path, n = 30) readf(path, n)

tailf <- function(path, n = 30) {
  path <- path.expand(path)
  
  if (!file.exists(path)) {
    cat("❌ Không thấy file:", path, "\n")
    return(invisible(NULL))
  }
  
  x <- readLines(path, warn = FALSE, encoding = "UTF-8")
  x <- tail(x, n)
  
  cat(paste(x, collapse = "\n"), "\n")
  invisible(x)
}

# ==== FIND TEXT INSIDE FILES ====

xml_to_text <- function(z) {
  z <- gsub("</w:p>|</a:p>|</row>|</si>", " ", z)
  z <- gsub("<w:tab[^>]*/>|<a:br[^>]*/>|<w:br[^>]*/>", " ", z)
  z <- gsub("<[^>]+>", "", z)
  z <- gsub("&amp;", "&", z, fixed = TRUE)
  z <- gsub("&lt;", "<", z, fixed = TRUE)
  z <- gsub("&gt;", ">", z, fixed = TRUE)
  z <- gsub("&quot;", "\"", z, fixed = TRUE)
  z <- gsub("&apos;", "'", z, fixed = TRUE)
  gsub("[[:space:]]+", " ", z)
}

read_xml_files <- function(files) {
  if (!length(files)) return("")
  out <- vapply(files, function(f) {
    z <- tryCatch(
      paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = " "),
      error = function(e) ""
    )
    xml_to_text(z)
  }, character(1))
  paste(out, collapse = " ")
}

read_docx_text <- function(file) {
  td <- tempfile("docx_")
  dir.create(td)
  on.exit(unlink(td, recursive = TRUE, force = TRUE), add = TRUE)
  
  ok <- tryCatch({
    utils::unzip(file, exdir = td)
    TRUE
  }, error = function(e) FALSE)
  
  if (!ok) return("")
  
  wd <- file.path(td, "word")
  
  fs <- c(
    file.path(wd, "document.xml"),
    list.files(
      wd,
      pattern = "^(header|footer|footnotes|endnotes|comments).*\\.xml$",
      full.names = TRUE
    )
  )
  
  fs <- unique(fs[file.exists(fs)])
  read_xml_files(fs)
}

read_pptx_text <- function(file) {
  td <- tempfile("pptx_")
  dir.create(td)
  on.exit(unlink(td, recursive = TRUE, force = TRUE), add = TRUE)
  
  ok <- tryCatch({
    utils::unzip(file, exdir = td)
    TRUE
  }, error = function(e) FALSE)
  
  if (!ok) return("")
  
  fs <- c(
    list.files(
      file.path(td, "ppt", "slides"),
      pattern = "^slide[0-9]+\\.xml$",
      full.names = TRUE
    ),
    list.files(
      file.path(td, "ppt", "notesSlides"),
      pattern = "^notesSlide[0-9]+\\.xml$",
      full.names = TRUE
    )
  )
  
  read_xml_files(fs)
}

read_xlsx_xml_text <- function(file) {
  td <- tempfile("xlsx_")
  dir.create(td)
  on.exit(unlink(td, recursive = TRUE, force = TRUE), add = TRUE)
  
  ok <- tryCatch({
    utils::unzip(file, exdir = td)
    TRUE
  }, error = function(e) FALSE)
  
  if (!ok) return("")
  
  fs <- c(
    file.path(td, "xl", "sharedStrings.xml"),
    list.files(
      file.path(td, "xl", "worksheets"),
      pattern = "^sheet[0-9]+\\.xml$",
      full.names = TRUE
    )
  )
  
  fs <- unique(fs[file.exists(fs)])
  read_xml_files(fs)
}

read_pdf_text <- function(file) {
  if (requireNamespace("pdftools", quietly = TRUE)) {
    x <- tryCatch(pdftools::pdf_text(file), error = function(e) character(0))
    return(paste(x, collapse = " "))
  }
  
  cmds <- c(
    "/opt/homebrew/bin/pdftotext",
    "/usr/local/bin/pdftotext",
    "/usr/bin/pdftotext"
  )
  cmd <- cmds[file.exists(cmds)][1]
  
  if (!is.na(cmd)) {
    out <- tempfile(fileext = ".txt")
    on.exit(unlink(out, force = TRUE), add = TRUE)
    
    status <- suppressWarnings(system(
      paste(shQuote(cmd), shQuote(file), shQuote(out)),
      ignore.stdout = TRUE,
      ignore.stderr = TRUE
    ))
    
    if (identical(status, 0L) && file.exists(out)) {
      x <- readLines(out, warn = FALSE, encoding = "UTF-8")
      return(paste(x, collapse = " "))
    }
  }
  
  ""
}

read_xls_text <- function(file) {
  if (!requireNamespace("readxl", quietly = TRUE)) return("")
  
  sheets <- tryCatch(readxl::excel_sheets(file), error = function(e) character(0))
  if (!length(sheets)) return("")
  
  out <- character(0)
  
  for (s in sheets) {
    z <- tryCatch(
      readxl::read_excel(file, sheet = s, col_names = FALSE),
      error = function(e) NULL
    )
    if (!is.null(z)) {
      out <- c(out, unlist(lapply(z, as.character), use.names = FALSE))
    }
  }
  
  paste(out, collapse = " ")
}

read_any_text <- function(file) {
  ext <- tolower(tools::file_ext(file))
  
  if (ext == "docx") return(read_docx_text(file))
  if (ext == "pptx") return(read_pptx_text(file))
  if (ext == "pdf")  return(read_pdf_text(file))
  if (ext == "xlsx") return(read_xlsx_xml_text(file))
  if (ext == "xls")  return(read_xls_text(file))
  
  text_ext <- c(
    "md","txt","r","rmd","qmd","csv","tsv",
    "html","htm","json","yaml","yml","bib","csl","log"
  )
  
  if (ext %in% text_ext) {
    x <- tryCatch(
      readLines(file, warn = FALSE, encoding = "UTF-8"),
      error = function(e) character(0)
    )
    return(paste(x, collapse = " "))
  }
  
  ""
}

f <- function(text, path = ".", n = 50, ignore.case = TRUE) {
  exts <- c(
    "docx","pptx","pdf","xlsx","xls",
    "md","txt","r","rmd","qmd","csv","tsv",
    "html","htm","json","yaml","yml","bib","csl","log"
  )
  
  files <- list.files(
    path,
    recursive = TRUE,
    full.names = TRUE,
    no.. = TRUE
  )
  
  files <- files[
    !grepl("^~\\$", basename(files)) &
      tolower(tools::file_ext(files)) %in% exts
  ]
  
  if (!length(files)) {
    cat("📭 Không có file phù hợp\n")
    return(invisible(NULL))
  }
  
  query <- if (ignore.case) tolower(text) else text
  hit_files <- character(0)
  hit_count <- integer(0)
  
  cat("🔎", text, "\n")
  
  for (file in files) {
    txt <- read_any_text(file)
    if (!nzchar(txt)) next
    
    hay <- if (ignore.case) tolower(txt) else txt
    m <- gregexpr(query, hay, fixed = TRUE)[[1]]
    
    if (m[1] != -1) {
      hit_files <- c(hit_files, file)
      hit_count <- c(hit_count, length(m))
    }
  }
  
  if (!length(hit_files)) {
    cat("❌ Không tìm thấy\n")
    
    if (!requireNamespace("pdftools", quietly = TRUE) &&
        !any(file.exists(c(
          "/opt/homebrew/bin/pdftotext",
          "/usr/local/bin/pdftotext",
          "/usr/bin/pdftotext"
        )))) {
      cat("ℹ️ PDF chưa đọc được: cài pdftools bằng install.packages('pdftools')\n")
    }
    
    return(invisible(NULL))
  }
  
  ord <- order(hit_count, decreasing = TRUE)
  hit_files <- head(hit_files[ord], n)
  hit_count <- head(hit_count[ord], n)
  
  .last_files <<- normalizePath(
    hit_files,
    winslash = "/",
    mustWork = TRUE
  )
  
  for (i in seq_along(hit_files)) {
    ext <- toupper(tools::file_ext(hit_files[i]))
    cat(sprintf(
      "%3d. %-5s [%dx] %s\n",
      i,
      ext,
      hit_count[i],
      proj_rel(hit_files[i])
    ))
  }
  
  cat("→ o(1) mở | vf(1) Finder | vc(1) Commander One\n")
  invisible(hit_files)
}

# ==== QUARTO ====

render_qmd <- function(file) {
  if (!requireNamespace("quarto", quietly = TRUE)) {
    stop("Chưa cài package quarto")
  }
  
  f <- normalizePath(file, winslash = "/", mustWork = TRUE)
  quarto::quarto_render(f)
  
  candidates <- c(
    sub("\\.qmd$", ".docx", f, ignore.case = TRUE),
    sub("\\.qmd$", ".html", f, ignore.case = TRUE),
    sub("\\.qmd$", ".pdf",  f, ignore.case = TRUE)
  )
  
  out <- candidates[file.exists(candidates)][1]
  if (length(out) && !is.na(out)) open_file(out)
  
  invisible(out)
}

rn <- function(file = .project_qmd) {
  f <- if (file.exists(file)) file else file.path(proj_root(), file)
  render_qmd(f)
}

ro <- function() {
  if (!requireNamespace("rstudioapi", quietly = TRUE)) {
    stop("Cần chạy trong RStudio")
  }
  
  f <- rstudioapi::getActiveDocumentContext()$path
  
  if (!nzchar(f) || !grepl("\\.qmd$", f, ignore.case = TRUE)) {
    stop("File đang mở không phải .qmd")
  }
  
  render_qmd(f)
}

# ==== GIT ====

get_git_branch <- function() {
  x <- tryCatch(
    system2("git", c("branch", "--show-current"), stdout = TRUE, stderr = FALSE),
    error = function(e) character(0)
  )
  if (!length(x) || !nzchar(trimws(x[1]))) "NA" else trimws(x[1])
}

gs <- function() {
  system("git status -sb")
  invisible(NULL)
}

gl <- function(n = 10) {
  system(sprintf("git log --oneline --graph --decorate -n %d", as.integer(n)))
  invisible(NULL)
}

gpull <- function() {
  system("git pull --rebase")
  invisible(NULL)
}

gp <- function(msg = "update") {
  if (requireNamespace("rstudioapi", quietly = TRUE)) {
    try(rstudioapi::executeCommand("saveAllSourceDocs"), silent = TRUE)
  }
  
  full_msg <- paste0("[", get_git_branch(), "] ", trimws(msg))
  
  system("git add -A")
  
  if (identical(system("git diff --cached --quiet"), 0L)) {
    cat("📭 Không có thay đổi\n")
    return(invisible(NULL))
  }
  
  if (!identical(system(paste("git commit -m", shQuote(full_msg))), 0L)) {
    cat("❌ Commit lỗi\n")
    return(invisible(NULL))
  }
  
  if (identical(system("git push"), 0L)) {
    cat("🚀 Đã push\n")
  } else {
    cat("⚠️ Commit xong nhưng push lỗi\n")
  }
  
  invisible(full_msg)
}


# ==== ÂM LỊCH ====
jd_from_date <- function(dd, mm, yy) {
  a <- floor((14 - mm) / 12)
  y <- yy + 4800 - a
  m <- mm + 12 * a - 3
  jd <- dd + floor((153 * m + 2) / 5) + 365 * y +
    floor(y / 4) - floor(y / 100) + floor(y / 400) - 32045
  if (jd < 2299161) {
    jd <- dd + floor((153 * m + 2) / 5) + 365 * y + floor(y / 4) - 32083
  }
  jd
}

new_moon_day <- function(k, time_zone = 7) {
  T <- k / 1236.85; T2 <- T * T; T3 <- T2 * T; dr <- pi / 180
  Jd1 <- 2415020.75933 + 29.53058868 * k + 0.0001178 * T2 - 0.000000155 * T3
  Jd1 <- Jd1 + 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr)
  M <- 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347 * T3
  Mpr <- 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236 * T3
  F <- 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239 * T3
  C1 <- (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M) -
    0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr) - 0.0004 * sin(dr * 3 * Mpr) +
    0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr)) - 0.0074 * sin(dr * (M - Mpr)) +
    0.0004 * sin(dr * (2 * F + M)) - 0.0004 * sin(dr * (2 * F - M)) -
    0.0006 * sin(dr * (2 * F + Mpr)) + 0.0010 * sin(dr * (2 * F - Mpr)) +
    0.0005 * sin(dr * (2 * Mpr + M))
  deltat <- if (T < -11) {
    0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3 - 0.000000081 * T * T3
  } else {
    -0.000278 + 0.000265 * T + 0.000262 * T2
  }
  floor(Jd1 + C1 - deltat + 0.5 + time_zone / 24)
}

sun_longitude <- function(jdn, time_zone = 7) {
  T <- (jdn - 2451545.5 - time_zone / 24) / 36525
  T2 <- T * T; dr <- pi / 180
  M <- 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2
  L0 <- 280.46645 + 36000.76983 * T + 0.0003032 * T2
  DL <- (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M) +
    (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.000290 * sin(dr * 3 * M)
  L <- (L0 + DL) * dr
  L <- L - pi * 2 * floor(L / (pi * 2))
  floor(L / pi * 6)
}

lunar_month_11 <- function(yy, time_zone = 7) {
  off <- jd_from_date(31, 12, yy) - 2415021
  k <- floor(off / 29.530588853)
  nm <- new_moon_day(k, time_zone)
  if (sun_longitude(nm, time_zone) >= 9) nm <- new_moon_day(k - 1, time_zone)
  nm
}

leap_month_offset <- function(a11, time_zone = 7) {
  k <- floor(0.5 + (a11 - 2415021.076998695) / 29.530588853)
  last <- 0; i <- 1
  arc <- sun_longitude(new_moon_day(k + i, time_zone), time_zone)
  repeat {
    last <- arc; i <- i + 1
    arc <- sun_longitude(new_moon_day(k + i, time_zone), time_zone)
    if (arc == last || i >= 14) break
  }
  i - 1
}

solar_to_lunar <- function(dd, mm, yy, time_zone = 7) {
  day_number <- jd_from_date(dd, mm, yy)
  k <- floor((day_number - 2415021.076998695) / 29.530588853)
  month_start <- new_moon_day(k + 1, time_zone)
  if (month_start > day_number) month_start <- new_moon_day(k, time_zone)
  
  a11 <- lunar_month_11(yy, time_zone); b11 <- a11
  if (a11 >= month_start) {
    lunar_year <- yy
    a11 <- lunar_month_11(yy - 1, time_zone)
  } else {
    lunar_year <- yy + 1
    b11 <- lunar_month_11(yy + 1, time_zone)
  }
  
  lunar_day <- day_number - month_start + 1
  diff <- floor((month_start - a11) / 29)
  lunar_leap <- 0
  lunar_month <- diff + 11
  
  if (b11 - a11 > 365) {
    leap_diff <- leap_month_offset(a11, time_zone)
    if (diff >= leap_diff) {
      lunar_month <- diff + 10
      if (diff == leap_diff) lunar_leap <- 1
    }
  }
  
  if (lunar_month > 12) lunar_month <- lunar_month - 12
  if (lunar_month >= 11 && diff < 4) lunar_year <- lunar_year - 1
  list(day = lunar_day, month = lunar_month, year = lunar_year, leap = lunar_leap)
}

can_chi_year <- function(year) {
  can <- c("Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý")
  chi <- c("Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi")
  paste(can[(year + 6) %% 10 + 1], chi[(year + 8) %% 12 + 1])
}

gio_chi <- function(hour) {
  chi <- c("Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi")
  if (hour %in% c(23, 0)) return("Tý")
  chi[floor((hour - 1) / 2) + 2]
}

n <- function() {
  d <- Sys.time(); dt <- as.Date(d)
  dd <- as.integer(format(dt, "%d")); mm <- as.integer(format(dt, "%m")); yy <- as.integer(format(dt, "%Y"))
  hh <- as.integer(format(d, "%H"))
  am <- solar_to_lunar(dd, mm, yy)
  thu <- c("Chủ nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy")[as.integer(format(dt, "%w")) + 1]
  out <- paste0(thu, ", ", format(d, "%d/%m/%Y %H:%M"),
                " | Âm lịch: ", am$day, "/", am$month,
                ifelse(am$leap == 1, " nhuận", ""),
                " năm ", can_chi_year(am$year), ", giờ ", gio_chi(hh))
  cat(out, "\n")
  invisible(out)
}

dl <- function(x) {
  x <- trimws(as.character(x))
  p <- strsplit(x, "\\s+")[[1]]
  date_part <- p[1]
  time_part <- if (length(p) >= 2) p[2] else NA_character_
  
  if (nchar(date_part) != 6 || grepl("[^0-9]", date_part)) {
    stop("Nhập YYMMDD hoặc 'YYMMDD HH:MM', ví dụ '750819' hoặc '750819 5:00'")
  }
  
  yy <- as.integer(substr(date_part, 1, 2))
  mm <- as.integer(substr(date_part, 3, 4))
  dd <- as.integer(substr(date_part, 5, 6))
  yy <- ifelse(yy >= 50, 1900 + yy, 2000 + yy)
  
  am <- solar_to_lunar(dd, mm, yy)
  out <- paste0(sprintf("%02d/%02d/%04d", dd, mm, yy), " → ",
                am$day, "/", am$month, ifelse(am$leap == 1, " nhuận", ""),
                " năm ", can_chi_year(am$year))
  
  if (!is.na(time_part)) {
    hh <- suppressWarnings(as.integer(sub(":.*$", "", time_part)))
    if (!is.na(hh) && hh >= 0 && hh <= 23) out <- paste0(out, ", giờ ", gio_chi(hh))
  }
  
  cat(out, "\n")
  invisible(out)
}


# ==== GIỜ DƯỠNG SINH ====
gio_duong_sinh_data <- function() {
  data.frame(
    start = c(3,5,7,9,11,13,15,17,19,21,23,1),
    end   = c(5,7,9,11,13,15,17,19,21,23,1,3),
    chi   = c("Dần","Mão","Thìn","Tỵ","Ngọ","Mùi","Thân","Dậu","Tuất","Hợi","Tý","Sửu"),
    kinh  = c("Phế","Đại tràng","Vị","Tỳ","Tâm","Tiểu tràng","Bàng quang","Thận","Tâm bào","Tam tiêu","Đảm","Can"),
    goi_y = c(
      "Ngủ sâu, tránh thức khuya.",
      "Uống nước ấm, đi tiêu.",
      "Ăn sáng đầy đủ.",
      "Giữ tinh thần thư thái.",
      "Nghỉ ngắn, thư thần.",
      "Uống nước đều.",
      "Vận động nhẹ.",
      "Ăn tối vừa phải.",
      "Giảm căng thẳng.",
      "Chuẩn bị ngủ.",
      "Ngủ ổn định.",
      "Nghỉ sâu."
    ),
    stringsAsFactors = FALSE
  )
}

g <- function(x = NULL) {
  if (is.null(x)) {
    hh <- as.integer(format(Sys.time(), "%H"))
    mm <- as.integer(format(Sys.time(), "%M"))
  } else {
    z <- strsplit(as.character(x), ":", fixed = TRUE)[[1]]
    hh <- suppressWarnings(as.integer(z[1]))
    mm <- if (length(z) > 1) suppressWarnings(as.integer(z[2])) else 0L
  }
  if (is.na(hh) || hh < 0 || hh > 23 || is.na(mm) || mm < 0 || mm > 59) {
    stop("Dùng g(), g(5), hoặc g('5:30')")
  }
  tb <- gio_duong_sinh_data()
  idx <- which((tb$start < tb$end & hh >= tb$start & hh < tb$end) |
                 (tb$start > tb$end & (hh >= tb$start | hh < tb$end)))
  z <- tb[idx[1], , drop = FALSE]
  out <- sprintf("%02d:%02d | giờ %s | %s kinh vượng | %s", hh, mm, z$chi, z$kinh, z$goi_y)
  cat("🌿", out, "\n")
  invisible(out)
}



# ==== GIT RECENT + TYPORA ====

# gf(n): file thay đổi gần nhất từ LOCAL + GIT HISTORY
# local -> dùng mtime
# commit/pull từ GitHub -> dùng commit time

gf <- function(n = 5) {

  root <- proj_root()
  old <- getwd()
  on.exit(setwd(old), add = TRUE)
  setwd(root)

  n <- suppressWarnings(as.integer(n[1]))
  if (is.na(n) || n < 1) n <- 5L

  # ---------------- LOCAL CHANGES ----------------
  unstaged <- tryCatch(
    system2('git', c('diff', '--name-only'), stdout = TRUE, stderr = FALSE),
    error = function(e) character(0)
  )

  staged <- tryCatch(
    system2('git', c('diff', '--cached', '--name-only'), stdout = TRUE, stderr = FALSE),
    error = function(e) character(0)
  )

  untracked <- tryCatch(
    system2('git', c('ls-files', '--others', '--exclude-standard'), stdout = TRUE, stderr = FALSE),
    error = function(e) character(0)
  )

  local_files <- unique(c(unstaged, staged, untracked))
  local_files <- local_files[nzchar(local_files)]

  local_files <- local_files[
    !grepl('^\\.Rprofile_backup_', basename(local_files))
  ]

  local_full <- file.path(root, local_files)
  keep <- file.exists(local_full)
  local_files <- local_files[keep]
  local_full <- local_full[keep]

  local_time <- if (length(local_full)) {
    as.numeric(file.info(local_full)$mtime)
  } else {
    numeric(0)
  }

  # ---------------- GIT HISTORY ----------------
  # @@TIME đánh dấu thời gian từng commit
  hist <- tryCatch(
    system2(
      'git',
      c(
        'log',
        '--all',
        '--name-only',
        '--format=@@%ct'
      ),
      stdout = TRUE,
      stderr = FALSE
    ),
    error = function(e) character(0)
  )

  git_files <- character(0)
  git_time  <- numeric(0)
  current_time <- NA_real_

  if (length(hist)) {
    for (z in hist) {

      z <- trimws(z)
      if (!nzchar(z)) next

      if (grepl('^@@[0-9]+$', z)) {
        current_time <- suppressWarnings(
          as.numeric(sub('^@@', '', z))
        )
        next
      }

      if (!is.na(current_time)) {
        git_files <- c(git_files, z)
        git_time  <- c(git_time, current_time)
      }
    }
  }

  # git log mới -> cũ, nên giữ lần xuất hiện đầu tiên của mỗi file
  if (length(git_files)) {
    k <- !duplicated(git_files)
    git_files <- git_files[k]
    git_time  <- git_time[k]
  }

  git_files <- git_files[
    !grepl('^\\.Rprofile_backup_', basename(git_files))
  ]

  # đồng bộ lại time sau lọc backup
  if (length(git_time) > length(git_files)) {
    # rebuild an toàn từ history nếu có lệch do filter
    gf0 <- character(0)
    gt0 <- numeric(0)
    current_time <- NA_real_

    for (z in hist) {
      z <- trimws(z)
      if (!nzchar(z)) next

      if (grepl('^@@[0-9]+$', z)) {
        current_time <- suppressWarnings(
          as.numeric(sub('^@@', '', z))
        )
        next
      }

      if (!is.na(current_time) &&
          !grepl('^\\.Rprofile_backup_', basename(z)) &&
          !z %in% gf0) {
        gf0 <- c(gf0, z)
        gt0 <- c(gt0, current_time)
      }
    }

    git_files <- gf0
    git_time  <- gt0
  }

  git_full <- file.path(root, git_files)
  keep <- file.exists(git_full)
  git_files <- git_files[keep]
  git_full  <- git_full[keep]
  git_time  <- git_time[keep]

  # ---------------- GỘP LOCAL + GIT ----------------
  all_files <- unique(c(local_files, git_files))

  if (!length(all_files)) {
    cat('📭 Không tìm thấy file thay đổi gần đây\n')
    .last_files <<- character(0)
    return(invisible(character(0)))
  }

  latest_time <- numeric(length(all_files))
  source_type <- character(length(all_files))

  for (i in seq_along(all_files)) {

    f <- all_files[i]
    times <- numeric(0)
    src   <- character(0)

    j <- match(f, local_files)
    if (!is.na(j)) {
      times <- c(times, local_time[j])
      src   <- c(src, 'LOCAL')
    }

    j <- match(f, git_files)
    if (!is.na(j)) {
      times <- c(times, git_time[j])
      src   <- c(src, 'GIT')
    }

    k <- which.max(times)
    latest_time[i] <- times[k]
    source_type[i] <- src[k]
  }

  ord <- order(latest_time, decreasing = TRUE)
  all_files   <- all_files[ord]
  latest_time <- latest_time[ord]
  source_type <- source_type[ord]

  all_files   <- head(all_files, n)
  latest_time <- head(latest_time, n)
  source_type <- head(source_type, n)

  full <- file.path(root, all_files)

  .last_files <<- normalizePath(
    full,
    winslash = '/',
    mustWork = TRUE
  )

  cat(sprintf(
    '🔀 %d file thay đổi gần nhất — LOCAL + GIT/GITHUB:\n',
    length(all_files)
  ))

  for (i in seq_along(all_files)) {

    ext <- toupper(tools::file_ext(all_files[i]))
    if (!nzchar(ext)) ext <- '-'

    tm <- format(
      as.POSIXct(latest_time[i], origin = '1970-01-01'),
      '%m-%d %H:%M'
    )

    cat(sprintf(
      '%3d. %-6s %-5s %s  %s\n',
      i, ext, source_type[i], tm, all_files[i]
    ))
  }

  cat('→ o(1) mặc định | ot(1) Typora nếu MD | vf(1) Finder | vc(1) Commander One\n')

  invisible(.last_files)
}


# Mở Markdown bằng Typora
ot <- function(x) {

  if (missing(x)) {
    cat("Dùng: ot(1) hoặc ot('file.md')\n")
    return(invisible(NULL))
  }

  if (is.numeric(x)) {
    f <- get_num_file(x)
    if (is.null(f)) return(invisible(NULL))
  } else {
    f <- path.expand(as.character(x[1]))

    if (!file.exists(f)) {
      f2 <- file.path(proj_root(), f)
      if (file.exists(f2)) f <- f2
    }

    if (!file.exists(f)) {
      cat('❌ Không thấy file:', f, '\n')
      return(invisible(NULL))
    }

    f <- normalizePath(f, winslash = '/', mustWork = TRUE)
  }

  ext <- tolower(tools::file_ext(f))

  if (ext != 'md') {
    cat('⚠️ ot() chỉ mở Markdown bằng Typora\n')
    cat('→ File này dùng o() để mở bằng app mặc định\n')
    return(invisible(NULL))
  }

  if (!dir.exists('/Applications/Typora.app')) {
    cat('❌ Không tìm thấy Typora\n')
    return(invisible(NULL))
  }

  system2(
    '/usr/bin/open',
    c('-a', 'Typora', f),
    stdout = FALSE,
    stderr = FALSE
  )

  cat('📝 Typora:', proj_rel(f), '\n')
  invisible(f)
}

# ==== END GIT RECENT + TYPORA ====


# ==== GIT CHANGE VIEWER ====

.git_changes <- function(commit = 'HEAD') {

  root <- proj_root()
  old <- getwd()
  on.exit(setwd(old), add = TRUE)
  setwd(root)

  z <- tryCatch(
    system2(
      'git',
      c(
        'show',
        '--format=',
        '--unified=0',
        '--no-ext-diff',
        commit
      ),
      stdout = TRUE,
      stderr = FALSE
    ),
    error = function(e) character(0)
  )

  if (!length(z)) {
    return(data.frame())
  }

  out_type <- character(0)
  out_file <- character(0)
  out_line <- integer(0)
  out_text <- character(0)

  current_old_file <- ''
  current_new_file <- ''
  old_line <- NA_integer_
  new_line <- NA_integer_

  for (s in z) {

    if (startsWith(s, '--- ')) {
      current_old_file <- sub('^--- a/', '', s)
      next
    }

    if (startsWith(s, '+++ ')) {
      current_new_file <- sub('^\\+\\+\\+ b/', '', s)
      next
    }

    if (startsWith(s, '@@')) {

      m <- regexec(
        '@@ -([0-9]+)(?:,[0-9]+)? \\+([0-9]+)(?:,[0-9]+)? @@',
        s
      )

      r <- regmatches(s, m)[[1]]

      if (length(r) >= 3) {
        old_line <- as.integer(r[2])
        new_line <- as.integer(r[3])
      }

      next
    }

    if (startsWith(s, '+') && !startsWith(s, '+++')) {

      out_type <- c(out_type, 'INSERT')
      out_file <- c(out_file, current_new_file)
      out_line <- c(out_line, new_line)
      out_text <- c(out_text, substring(s, 2))

      new_line <- new_line + 1L
      next
    }

    if (startsWith(s, '-') && !startsWith(s, '---')) {

      out_type <- c(out_type, 'DELETE')
      out_file <- c(out_file, current_old_file)
      out_line <- c(out_line, old_line)
      out_text <- c(out_text, substring(s, 2))

      old_line <- old_line + 1L
      next
    }

    if (startsWith(s, ' ')) {
      old_line <- old_line + 1L
      new_line <- new_line + 1L
    }
  }

  data.frame(
    type = out_type,
    file = out_file,
    line = out_line,
    text = out_text,
    stringsAsFactors = FALSE
  )
}


.print_git_changes <- function(d, title) {

  if (!nrow(d)) {
    cat('📭 Không có thay đổi\n')
    return(invisible(d))
  }

  cat('\n', title, '\n', sep = '')

  for (i in seq_len(nrow(d))) {

    txt <- d$text[i]

    if (nchar(txt) > 100) {
      txt <- paste0(substr(txt, 1, 97), '...')
    }

    cat(sprintf(
      '%3d. %-5s L%-5s %s\n',
      i,
      basename(d$file[i]),
      d$line[i],
      txt
    ))
  }

  invisible(d)
}


# Xem toàn bộ INSERT / DELETE của commit
gchg <- function(commit = 'HEAD') {

  d <- .git_changes(commit)

  if (!nrow(d)) {
    cat('📭 Commit không có thay đổi text\n')
    return(invisible(d))
  }

  ins <- d[d$type == 'INSERT', , drop = FALSE]
  del <- d[d$type == 'DELETE', , drop = FALSE]

  cat('🔎 Git change:', commit, '\n')
  cat(sprintf(
    '➕ %d insertions | ➖ %d deletions\n',
    nrow(ins),
    nrow(del)
  ))

  .print_git_changes(ins, '➕ INSERT')
  .print_git_changes(del, '➖ DELETE')

  invisible(d)
}


# INSERT
# gi()                -> 10 insert cuối
# gi(5)               -> 5 insert cuối
# gi(c(1,2,3,5))      -> đúng các số 1,2,3,5
gi <- function(x = 10, commit = 'HEAD') {

  d <- .git_changes(commit)
  d <- d[d$type == 'INSERT', , drop = FALSE]

  if (!nrow(d)) {
    cat('📭 Không có INSERT\n')
    return(invisible(d))
  }

  # 1 số -> lấy n dòng CUỐI
  if (length(x) == 1) {

    n <- suppressWarnings(as.integer(x))

    if (is.na(n) || n < 1) n <- 10L

    idx <- tail(seq_len(nrow(d)), n)
    z <- d[idx, , drop = FALSE]

    # đánh số theo vị trí thật trong toàn bộ INSERT
    rownames(z) <- idx

    cat(sprintf(
      '➕ %d INSERT cuối / tổng %d:\n',
      nrow(z),
      nrow(d)
    ))

    for (j in seq_len(nrow(z))) {

      real_i <- idx[j]
      txt <- z$text[j]

      if (nchar(txt) > 100) {
        txt <- paste0(substr(txt, 1, 97), '...')
      }

      cat(sprintf(
        '%3d. %-5s L%-5s %s\n',
        real_i,
        basename(z$file[j]),
        z$line[j],
        txt
      ))
    }

    return(invisible(z))
  }

  # vector -> lấy đúng các số
  idx <- suppressWarnings(as.integer(x))
  idx <- idx[!is.na(idx) & idx >= 1 & idx <= nrow(d)]

  if (!length(idx)) {
    cat('❌ Số INSERT không hợp lệ\n')
    return(invisible(NULL))
  }

  z <- d[idx, , drop = FALSE]

  cat('➕ INSERT được chọn:\n')

  for (j in seq_along(idx)) {

    txt <- z$text[j]

    if (nchar(txt) > 100) {
      txt <- paste0(substr(txt, 1, 97), '...')
    }

    cat(sprintf(
      '%3d. %-5s L%-5s %s\n',
      idx[j],
      basename(z$file[j]),
      z$line[j],
      txt
    ))
  }

  invisible(z)
}


# DELETE
# gd()           -> 10 delete cuối
# gd(5)          -> 5 delete cuối
# gd(c(1,2,5))   -> đúng delete số 1,2,5
gd <- function(x = 10, commit = 'HEAD') {

  d <- .git_changes(commit)
  d <- d[d$type == 'DELETE', , drop = FALSE]

  if (!nrow(d)) {
    cat('📭 Không có DELETE\n')
    return(invisible(d))
  }

  if (length(x) == 1) {

    n <- suppressWarnings(as.integer(x))

    if (is.na(n) || n < 1) n <- 10L

    idx <- tail(seq_len(nrow(d)), n)
    z <- d[idx, , drop = FALSE]

    cat(sprintf(
      '➖ %d DELETE cuối / tổng %d:\n',
      nrow(z),
      nrow(d)
    ))

    for (j in seq_len(nrow(z))) {

      real_i <- idx[j]
      txt <- z$text[j]

      if (nchar(txt) > 100) {
        txt <- paste0(substr(txt, 1, 97), '...')
      }

      cat(sprintf(
        '%3d. %-5s L%-5s %s\n',
        real_i,
        basename(z$file[j]),
        z$line[j],
        txt
      ))
    }

    return(invisible(z))
  }

  idx <- suppressWarnings(as.integer(x))
  idx <- idx[!is.na(idx) & idx >= 1 & idx <= nrow(d)]

  if (!length(idx)) {
    cat('❌ Số DELETE không hợp lệ\n')
    return(invisible(NULL))
  }

  z <- d[idx, , drop = FALSE]

  cat('➖ DELETE được chọn:\n')

  for (j in seq_along(idx)) {

    txt <- z$text[j]

    if (nchar(txt) > 100) {
      txt <- paste0(substr(txt, 1, 97), '...')
    }

    cat(sprintf(
      '%3d. %-5s L%-5s %s\n',
      idx[j],
      basename(z$file[j]),
      z$line[j],
      txt
    ))
  }

  invisible(z)
}

# ==== END GIT CHANGE VIEWER ====

# ==== HELP ====

hhelp <- function() {
  cat("
FILES   tree()  recent()  lsd()  lsf()  ff('tên file')
FIND    f('cụm từ')          tìm trong DOCX/PPTX/PDF/XLSX/MD/R/QMD...
OPEN    o(1)  ot(1)  vf(1)  vc(1)  v(1)
READ    readf('x.md')  headf('x.R')  tailf('x.R')
DIR     wd()  pj()  cd('folder')  up()
GIT     gs()  gf()  gl()  gpull()  gp('msg')  gchg()  gi(5)  gd(5)
TIME    n()  dl('750819')  g()
TÂM     hh()  np()
QMD     rn()  ro()
", sep = "\n")
  invisible(NULL)
}

# ==== STARTUP ====

if (interactive()) {
  cat("📊 normative_van | hhelp() | tree() | recent() | f('text') | n() | hh()\n")
}

# ==== QUIET PDF SEARCH ====
read_pdf_text <- function(file) {
  if (!requireNamespace("pdftools", quietly = TRUE)) return("")

  x <- tryCatch(
    suppressWarnings(
      suppressMessages(
        pdftools::pdf_text(file)
      )
    ),
    error = function(e) character(0)
  )

  paste(x, collapse = " ")
}
