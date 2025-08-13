pacman::p_load(tidyverse, sjlabelled, readxl)

#データの読み込み---------------------------------------------------------------

folder_path_absence <- "data/raw/不登校生徒数"

file_path_absence <- list.files(folder_path_absence, full.names = TRUE)

file_name_absence <- 
  list.files(folder_path_absence, full.names = FALSE) |> 
  str_remove("_不登校生徒数.xlsx")

list_df_school_absence_raw <- 
  map(file_path_absence, \(path){
    
    read_xlsx(path)
    
  }) |> 
  setNames(file_name_absence)

df_student_num_raw <- 
  read_xlsx("data/raw/生徒数/生徒数.xlsx")

#変数名の変更-------------------------------------------------------------------

list_df_school_absence_original <- 
  list_df_school_absence_raw |> 
  map(\(df){
    
    df |> 
      rename(
        prefecture = "都道府県",
        n_absence = "不登校生徒数"
      ) |> 
      var_labels(
        prefecture = "都道府県",
        n_absence = "不登校生徒数"
      )
    
  })

df_student_num_original <- 
  df_student_num_raw |> 
  rename(
    prefecture = "都道府県",
    year = "年度",
    n_student = "生徒数"
  ) |> 
  var_labels(
    prefecture = "都道府県",
    year = "年度",
    n_student = "生徒数"
  )

#データの保存-------------------------------------------------------------------

# 1. 不登校生徒数データ
saveRDS(list_df_school_absence_original, 
        file = "data/original/list_df_school_absence_original.rds")

# 2. 生徒数データ
saveRDS(df_student_num_original,
        file = "data/original/df_student_num_original.rds")

