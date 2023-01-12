# extract and read zipped csv file obtained from Kaggle
# https://www.kaggle.com/mlg-ulb/creditcardfraud
creditcard = data.table::fread('unzip -p data-raw/creditcard.csv.zip')

# make response a factor with names instead of numbers
creditcard$Class = factor(ifelse(creditcard$Class == 0, "genuine", "fraud"))

# create data directory
if (!dir.exists("data")) {
  dir.create("data")
}

# create remote readable compressed file
data.table::fwrite(creditcard, file = "data/cc.csv.gz")

# read from gz file with modified response
cc = data.table::fread("data/cc.csv.gz")

# verify data
nrow(creditcard) == 284807
nrow(cc) == 284807
nrow(cc) == nrow(creditcard)

# create data subset
# set.seed(42)
# sub_idx = sample(nrow(cc), size = 10000)
# cc_sub = cc[sub_idx, ]


cc_sub1 = cc[cc$Class == "fraud"]
nrow(cc_sub1)
cc_sub2 = cc[cc$Class == "genuine"]
set.seed(42)
sub_idx = sample(nrow(cc_sub2), size = 492)
cc_sub3 = cc_sub2[sub_idx, ]
cc_sub = rbind(cc_sub1, cc_sub3)

# write subset to disk
data.table::fwrite(cc_sub, "data/cc-sub.csv")

# clean up
rm(creditcard, cc, sub_idx, cc_sub, cc_sub1, cc_sub2, cc_sub3)
