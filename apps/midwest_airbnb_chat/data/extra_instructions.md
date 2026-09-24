# Extra Instructions

Rules the LLM follows when it writes SQL for `listings`.

- `price` is the nightly price in U.S. dollars. When the user asks what something costs, use `price` and round money to whole dollars in the answer.

- `host_is_superhost` and `instant_bookable` are stored as text values. Use `t` for true and `f` for false; do not treat them as SQL booleans.

- Match city names case-insensitively so users can enter city names with different capitalization.

- When calculating averages using `review_scores_rating`, ignore rows where `review_scores_rating` is `NULL`.
