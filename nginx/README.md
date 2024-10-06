## Lua

- The activity_pre_load file preloads activity information for a product and caches it for faster future access.
- The activity_query file checks for cached activity information and queries the backend if it's not available locally.
- The black_user file manages request rate limiting and blacklisting users based on abnormal request rates.
- The set_common_variable file is used to parse and assign common variables like product ID, user ID, and st.
- The submit_access file checks user requests for blacklist violations and validates certain parameters before allowing them to proceed with a purchase.
