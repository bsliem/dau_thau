
# ============================================================
# HỌC CHỨNG CHỈ NGHIỆP VỤ CHUYÊN MÔN VỀ ĐẤU THẦU
#
# Lệnh chính:
#
#   dt()        học tiếp từ câu đang dở
#   dt(25)      mở thẳng câu 25
#   dt(25, 40)  học câu 25 -> 40
#
#   lui()       quay lại 1 câu
#   toi()       đi tới 1 câu
#
#   dtsai()     ôn các câu đã làm sai
#   tien_do()   xem tiến độ
#   reset_dt()  xóa tiến độ và học lại
#
# Trong lúc học:
#
#   A/B/C/D     trả lời
#   n           câu tiếp
#   p           câu trước
#   q           thoát và lưu vị trí
#
# ============================================================


ROOT <- path.expand("~/Documents/dau_thau")

PROGRESS_FILE <- file.path(
  ROOT,
  "progress",
  "tien_do.rds"
)


# ============================================================
# DỮ LIỆU
# Tạm thời nhập câu 1-10.
# Sau này sẽ thay bằng toàn bộ 390 câu.
# ============================================================

questions <- list(

  list(
    id = 1,
    q = "Trường hợp nào sau đây bắt buộc phải lựa chọn nhà thầu theo quy định tại Luật Đấu thầu?",
    A = "Gói thầu thuộc dự án sử dụng vốn ngân sách nhà nước của cơ quan nhà nước",
    B = "Lựa chọn nhà thầu của doanh nghiệp nhà nước không sử dụng vốn ngân sách nhà nước",
    C = "Lựa chọn nhà thầu của đơn vị sự nghiệp công lập tự bảo đảm chi thường xuyên không sử dụng ngân sách nhà nước",
    D = "Việc thuê, mua, thuê mua nhà, trụ sở, tài sản gắn liền với đất",
    ans = "A"
  ),

  list(
    id = 2,
    q = "Chọn phương án đúng về phạm vi điều chỉnh của Luật Đấu thầu?",
    A = "Quy định về quản lý nhà nước đối với hoạt động đấu thầu",
    B = "Quy định về thẩm quyền và trách nhiệm của các cơ quan, tổ chức, cá nhân trong hoạt động đấu thầu",
    C = "Quy định về hoạt động lựa chọn nhà thầu thực hiện gói thầu, hoạt động lựa chọn nhà đầu tư thực hiện dự án đầu tư kinh doanh",
    D = "Tất cả phương án trên đều đúng",
    ans = "D"
  ),

  list(
    id = 3,
    q = "Trường hợp nào sau đây không thuộc đối tượng áp dụng của Luật Đấu thầu?",
    A = "Gói thầu mua thuốc, hóa chất, vật tư xét nghiệm sử dụng nguồn ngân sách nhà nước của bệnh viện công lập A",
    B = "Gói thầu xây dựng đường giao thông sử dụng vốn đầu tư công",
    C = "Gói thầu mua sắm trang thiết bị làm việc sử dụng vốn nhà nước",
    D = "Hoạt động mua phần mềm kế toán của hộ kinh doanh cá thể",
    ans = "D"
  ),

  list(
    id = 4,
    q = "Theo quy định pháp luật về đấu thầu, gói thầu nào là gói thầu cung cấp dịch vụ tư vấn?",
    A = "Thiết kế và cung cấp hệ thống xử lý nước thải",
    B = "Gói thầu lập nhiệm vụ quy hoạch vùng",
    C = "Gói thầu quảng cáo trên nền tảng xã hội và phát sóng trên VTV",
    D = "Gói thầu mua phần mềm kế toán MISA",
    ans = "B"
  ),

  list(
    id = 5,
    q = "Theo quy định pháp luật về đấu thầu, gói thầu nào là gói thầu cung cấp dịch vụ phi tư vấn?",
    A = "Gói thầu in sổ công tác của tỉnh A",
    B = "Gói thầu thuê kiểm toán dự án",
    C = "Gói thầu mua phần mềm kế toán",
    D = "Gói thầu xây dựng trụ sở làm việc",
    ans = "A"
  ),

  list(
    id = 6,
    q = "Theo quy định pháp luật về đấu thầu, đấu thầu là gì?",
    A = "Quá trình lựa chọn nhà thầu để ký kết, thực hiện hợp đồng",
    B = "Quá trình lựa chọn nhà đầu tư để ký kết, thực hiện hợp đồng dự án đầu tư kinh doanh",
    C = "Quá trình lựa chọn đơn vị thực hiện hợp đồng thông qua quy trình đấu thầu",
    D = "Phương án A và B đều đúng",
    ans = "D"
  ),

  list(
    id = 7,
    q = "Đấu thầu quốc tế là gì?",
    A = "Hoạt động đấu thầu mà nhà thầu trong nước, nhà thầu nước ngoài được tham dự thầu",
    B = "Nhà thầu trong nước bắt buộc liên danh với nhà thầu nước ngoài",
    C = "Chỉ nhà thầu quốc tế được phép tham dự",
    D = "Chỉ nhà thầu trong nước được phép tham dự",
    ans = "A"
  ),

  list(
    id = 8,
    q = "Giá đề nghị trúng thầu là gì?",
    A = "Giá dự thầu ghi trong quyết định phê duyệt kết quả lựa chọn nhà thầu",
    B = "Giá dự thầu sau sửa lỗi, hiệu chỉnh sai lệch và trừ giá trị giảm giá nếu có",
    C = "Giá dự thầu chưa sửa lỗi, hiệu chỉnh sai lệch và giá trị giảm giá",
    D = "Giá trị ghi trong hợp đồng",
    ans = "B"
  ),

  list(
    id = 9,
    q = "Theo quy định pháp luật về đấu thầu, hàng hóa gồm?",
    A = "Máy móc, thiết bị, nguyên liệu, nhiên liệu, vật liệu, vật tư, phụ tùng; sản phẩm; phương tiện; hàng tiêu dùng, phần mềm thương mại",
    B = "Thuốc, hóa chất, vật tư xét nghiệm, thiết bị y tế",
    C = "Phương án A và B đều đúng",
    D = "Logistics, bảo hiểm, quảng cáo, nghiệm thu chạy thử, chụp ảnh vệ tinh",
    ans = "C"
  ),

  list(
    id = 10,
    q = "Đối tượng nào sau đây được hưởng ưu đãi trong lựa chọn nhà thầu?",
    A = "Hàng hóa có xuất xứ Việt Nam",
    B = "Nhà thầu trong nước sản xuất hàng hóa có xuất xứ Việt Nam phù hợp hồ sơ mời thầu",
    C = "Sản phẩm, dịch vụ thân thiện môi trường",
    D = "Tất cả các phương án trên đều đúng",
    ans = "D"
  )
)


# ============================================================
# TIẾN ĐỘ
# ============================================================

load_progress <- function() {

  if (file.exists(PROGRESS_FILE)) {
    readRDS(PROGRESS_FILE)
  } else {
    list(
      current = 1,
      correct = integer(),
      wrong = integer(),
      history = data.frame(
        id = integer(),
        answer = character(),
        correct = logical(),
        time = as.POSIXct(character())
      )
    )
  }
}


save_progress <- function(p) {

  dir.create(
    dirname(PROGRESS_FILE),
    showWarnings = FALSE,
    recursive = TRUE
  )

  saveRDS(p, PROGRESS_FILE)
}


# ============================================================
# HIỂN THỊ
# ============================================================

show_question <- function(x) {

  cat("\n")
  cat("============================================================\n")
  cat(sprintf("📘 CÂU %d / %d\n", x$id, length(questions)))
  cat("============================================================\n\n")

  cat(strwrap(x$q, width = 78), sep = "\n")
  cat("\n\n")

  for (k in c("A", "B", "C", "D")) {

    txt <- paste0(k, ". ", x[[k]])

    cat(
      strwrap(
        txt,
        width = 78,
        exdent = 3
      ),
      sep = "\n"
    )

    cat("\n")
  }
}


# ============================================================
# HỌC
# ============================================================

dt <- function(from = NULL, to = NULL) {

  p <- load_progress()

  if (is.null(from))
    from <- p$current

  if (is.null(to))
    to <- length(questions)

  from <- max(1, from)
  to   <- min(length(questions), to)

  i <- from

  while (i >= 1 && i <= to) {

    x <- questions[[i]]

    p$current <- i
    save_progress(p)

    show_question(x)

    z <- trimws(
      toupper(
        readline(
          "👉 A/B/C/D | n: tới | p: lui | q: thoát > "
        )
      )
    )

    if (z == "Q") {

      p$current <- i
      save_progress(p)

      cat("\n💾 Đã lưu tại câu", i, "\n")
      return(invisible(p))
    }

    if (z == "P") {
      i <- max(1, i - 1)
      next
    }

    if (z == "N" || z == "") {
      i <- i + 1
      next
    }

    if (!z %in% c("A", "B", "C", "D")) {
      cat("\n⚠️ Nhập A, B, C, D, n, p hoặc q.\n")
      next
    }

    ok <- identical(z, x$ans)

    if (ok) {

      cat("\n✅ ĐÚNG!\n")

      p$correct <- unique(
        c(p$correct, x$id)
      )

      p$wrong <- setdiff(
        p$wrong,
        x$id
      )

    } else {

      cat("\n❌ SAI\n")
      cat("✅ Đáp án:", x$ans, "\n")
      cat("📖", x[[x$ans]], "\n")

      p$wrong <- unique(
        c(p$wrong, x$id)
      )
    }

    p$history <- rbind(
      p$history,
      data.frame(
        id = x$id,
        answer = z,
        correct = ok,
        time = Sys.time()
      )
    )

    p$current <- min(
      length(questions),
      i + 1
    )

    save_progress(p)

    readline("\n⏎ Enter để tiếp tục...")

    i <- i + 1
  }

  cat("\n🎉 Hết đoạn.\n")

  invisible(p)
}


# ============================================================
# ĐI TỚI / ĐI LÙI
# ============================================================

toi <- function(n = 1) {

  p <- load_progress()

  p$current <- min(
    length(questions),
    p$current + n
  )

  save_progress(p)

  dt(p$current)
}


lui <- function(n = 1) {

  p <- load_progress()

  p$current <- max(
    1,
    p$current - n
  )

  save_progress(p)

  dt(p$current)
}


# ============================================================
# ÔN CÂU SAI
# ============================================================

dtsai <- function() {

  p <- load_progress()

  ids <- sort(unique(p$wrong))

  if (!length(ids)) {
    cat("\n✅ Hiện chưa có câu sai cần ôn.\n")
    return(invisible(NULL))
  }

  cat("\n🔁 ÔN CÂU SAI:", paste(ids, collapse = ", "), "\n")

  for (id in ids) {

    x <- questions[[id]]

    show_question(x)

    z <- trimws(
      toupper(
        readline("👉 Đáp án > ")
      )
    )

    if (z == "Q")
      break

    if (z == x$ans) {

      cat("\n✅ ĐÚNG!\n")

      p$wrong <- setdiff(
        p$wrong,
        id
      )

      p$correct <- unique(
        c(p$correct, id)
      )

    } else {

      cat("\n❌ SAI — đáp án:", x$ans, "\n")
    }

    save_progress(p)

    readline("\n⏎ Enter...")
  }

  invisible(p)
}


# ============================================================
# XEM TIẾN ĐỘ
# ============================================================

tien_do <- function() {

  p <- load_progress()

  cat("\n📊 TIẾN ĐỘ HỌC ĐẤU THẦU\n")
  cat("----------------------------------------\n")
  cat("📍 Câu đang học :", p$current, "\n")
  cat("✅ Đã đúng      :", length(unique(p$correct)), "\n")
  cat("❌ Câu cần ôn   :", length(unique(p$wrong)), "\n")

  if (length(p$wrong))
    cat(
      "🔁 Câu sai      :",
      paste(sort(unique(p$wrong)), collapse = ", "),
      "\n"
    )

  cat(
    "📝 Tổng lượt làm:",
    nrow(p$history),
    "\n"
  )

  invisible(p)
}


# ============================================================
# RESET
# ============================================================

reset_dt <- function() {

  ans <- readline(
    "Xóa toàn bộ tiến độ? gõ YES để xác nhận: "
  )

  if (ans == "YES") {

    if (file.exists(PROGRESS_FILE))
      unlink(PROGRESS_FILE)

    cat("\n✅ Đã reset tiến độ.\n")

  } else {

    cat("\nKhông thay đổi.\n")
  }
}


cat("\n")
cat("✅ ĐÃ NẠP CHƯƠNG TRÌNH HỌC ĐẤU THẦU\n")
cat("\n")
cat("Lệnh:\n")
cat("  dt()         học tiếp\n")
cat("  dt(5)        từ câu 5\n")
cat("  dt(3, 8)     câu 3 đến 8\n")
cat("  lui()        lùi 1 câu\n")
cat("  toi()        tới 1 câu\n")
cat("  dtsai()      ôn câu sai\n")
cat("  tien_do()    xem tiến độ\n")
cat("\n")

