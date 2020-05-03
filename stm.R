# Importing required packages:
library(ezpickr)
library(tidyverse)
library(stm)
library(tidyverse)

# Loading data:
df <- ezpickr::pick("csv/full_us_dataset.csv")

# Text preprocessing:
mypreprocess <- stm::textProcessor(
  documents = df$content,
  metadata = df
)

# Preparing for STM document:
myout <- stm::prepDocuments(
  documents = mypreprocess$documents,
  vocab = mypreprocess$vocab,
  meta = mypreprocess$meta,
  lower.thresh = 0
)

# Search best K values:
documents <- myout$documents
vocab <- myout$vocab
meta <- myout$meta
set.seed(7777)
K <- c(5, 10, 15)
kresult <- stm::searchK(documents, vocab, K, prevalence = ~ factor(bias), data = meta)

# Plotting search_K_results:
plot(kresult)

# Tabling some stats related to search K results:
suppressWarnings(tidyr::unnest(kresult$results))

# Estimating model
mystm <- stm::stm(
  documents = myout$documents,
  vocab = myout$vocab,
  K = 6,
  prevalence = ~ factor(bias),
  data = myout$meta,
  init.type = "Spectral",
  seed = 7777,
  verbose = FALSE
)

# Taking a glimpse of each label per topic:
mylabels <- stm::labelTopics(
  model = mystm,
  topics = 1:6
)

# Visualization of top-20 words per each topic:
# It treats each document as a mixture of topics, and each topic as a mixture of words.
# Beta (per-topic-per-word probability): each topic as a mixture of words
td_beta <- tidytext::tidy(mystm, matrix = "beta")
td_beta

# Examine the topics
td_beta %>%
  group_by(topic) %>%
  top_n(20, beta) %>%
  ungroup() %>%
  ggplot(aes(term, beta)) +
  geom_col() +
  facet_wrap(~topic, scales = "free") +
  coord_flip()


# Graphing a correlation network:
mystm.corr <- stm::topicCorr(
  model = mystm
)

library(igraph)
plot(mystm.corr)


myresult <- stm::estimateEffect(
  formula = c(1:6) ~ factor(bias),
  stmobj = mystm,
  metadata = mypreprocess$meta
)

summary(myresult)
tidy_result <- tidytext::tidy(myresult)
