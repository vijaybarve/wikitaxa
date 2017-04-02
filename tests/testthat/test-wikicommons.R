context("wt_wikicommons")

test_that("wt_wikicommons returns non-empty results", {
  aa <- wt_wikicommons(name = "Malus domestica")

  expect_is(aa, "list")
  expect_named(aa, c('langlinks', 'externallinks', 'common_names',
                     'classification'))
  expect_is(aa$langlinks, "data.frame")
  expect_is(aa$externallinks, "character")
  expect_is(aa$common_names, "data.frame")
  expect_named(aa$common_names, c('name', 'language'))
  expect_is(aa$classification, "data.frame")
  expect_named(aa$classification, c('rank', 'name'))

  bb <- wt_wikicommons(name = "Poa annua")

  expect_is(bb, "list")
  expect_named(bb, c('langlinks', 'externallinks', 'common_names',
                     'classification'))
  expect_is(bb$langlinks, "data.frame")
  expect_is(bb$externallinks, "character")
  expect_is(bb$common_names, "data.frame")
  expect_named(bb$common_names, c('name', 'language'))
  expect_is(bb$classification, "data.frame")
  expect_named(bb$classification, c('rank', 'name'))
})

test_that("wt_wikicommons fails well", {
  expect_error(wt_wikicommons(),
            "argument \"name\" is missing")
  expect_error(wt_wikicommons(5),
               "name must be of class character")
})

context("wt_wikicommons_parse")

test_that("wt_wikicommons_parse returns non-empty results", {
  url <- "https://commons.wikimedia.org/wiki/Malus_domestica"
  pg <- wt_wiki_page(url)
  types <- c("common_names")
  result <- wt_wikicommons_parse(pg, types = types)
  expect_is(result, "list")
  for (fieldname in types) {
    expect_is(result[fieldname], "list")
    expect_gt(length(result[fieldname]), 0)
  }
})

context("wt_wikicommons_search")

test_that("wt_wikicommons_search works", {
  aa <- wt_wikicommons_search(query = "Pinus")

  expect_is(aa, "list")
  expect_is(aa$continue, "list")
  expect_is(aa$query, "list")
  expect_is(aa$query$searchinfo, "list")
  expect_is(aa$query$search, "data.frame")
  expect_named(aa$query$search, c('ns', 'title', 'size', 'wordcount',
                                  'snippet', 'timestamp'))

  # no results when not found
  expect_equal(NROW(wt_wikicommons_search("asdfadfaadfadfs")$query$search), 0)
})

test_that("wt_wikicommons_search fails well", {
  expect_error(
    wt_wikicommons_search(),
    "argument \"query\" is missing"
  )
  expect_error(
    wt_wikicommons_search("Pinus", limit = "adf"),
    "limit must be of class integer, numeric"
  )
  expect_error(
    wt_wikicommons_search("Pinus", offset = "adf"),
    "offset must be of class integer, numeric"
  )
})