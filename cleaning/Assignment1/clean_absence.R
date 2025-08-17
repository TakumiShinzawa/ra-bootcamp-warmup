pacman::p_load(tidyverse, sjlabelled)

#データ読み込み-----------------------------------------------------------------

list_df_school_absence_original <- 
  readRDS("data/original/list_df_school_absence_original.rds")

df_student_num_original <- 
  readRDS("data/original/df_student_num_original.rds")

#blank列を削除 + データ型変換 + 年追加-----------------------------------------

df_school_absence_cleaned <- 
  list_df_school_absence_original |> 
  map(\(df){
    
    df |> 
      select(!blank) |> 
      mutate(
        n_absence = as.numeric(n_absence),
        prefecture_index = row_number()
      )
    
  } ) |> 
  bind_rows(.id = "year") |> 
  relocate(prefecture) |> 
  mutate(year = as.numeric(str_remove(year, "年度"))) |> 
  arrange(prefecture_index, year) |> 
  select(!prefecture_index) |> 
  var_labels(
    prefecture = "都道府県",
    year = "年度",
    n_absence = "不登校生徒数"
  )

#生徒数データと結合-------------------------------------------------------------

df_school_absence <-
  df_student_num_original|> 
  left_join(df_school_absence_cleaned,
            by = c("prefecture", "year"))

#不登校割合の計算と追加--------------------------------------------------------

df_school_absence <- 
  df_school_absence |>
  mutate(absence_rate = (n_absence / n_student) * 100) |>
  var_labels(absence_rate = "不登校割合")

#保存---------------------------------------------------------------------------

saveRDS(df_school_absence, file = "data/cleaned/df_school_absence.rds")

