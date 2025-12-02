vim.b.miniclue_config = {
  triggers = {
    { mode = 'n', keys = 'c' },
    { mode = 'n', keys = 'd' },
  },
}

-- stylua: ignore start
local mappings = {
  -- Commit maps
  { 'n', 'cc', 'Create a commit' },
  { 'n', 'cvc', 'Create a commit with -v' },
  { 'n', 'ca', 'Amend the last commit and edit the message' },
  { 'n', 'cva', 'Amend the last commit with -v' },
  { 'n', 'ce', 'Amend the last commit without editing the message' },
  { 'n', 'cw', 'Reword the last commit' },
  { 'n', 'cW', 'Create an `amend!` commit that rewords the commit under the cursor' },
  { 'n', 'cf', 'Create a `fixup!` commit for the commit under the cursor' },
  { 'n', 'cF', 'Create a `fixup!` commit for the commit under the cursor and immediately rebase it' },
  { 'n', 'cs', 'Create a `squash!` commit for the commit under the cursor' },
  { 'n', 'cS', 'Create a `squash!` commit for the commit under the cursor and immediately rebase it' },
  { 'n', 'cn', 'Create a `squash!` commit for the commit under the cursor and edit the message' },
  { 'n', 'c<space>', 'Populate command line with ":Git commit "' },
  { 'n', 'c?', 'Show Fugitive commit help' },

  -- Revert and merge maps
  { 'n', 'crc', 'Revert the commit under the cursor' },
  { 'n', 'crn', 'Revert the commit under the cursor in the index and work tree, but do not actually commit the changes' },
  { 'n', 'cr<space>', 'Populate command line with ":Git revert "' },
  { 'n', 'cm<space>', 'Populate command line with ":Git merge "' },

  -- Stash maps
  { 'n', 'czz', 'Push stash; count 1 adds --include-untracked, 2 adds --all' },
  { 'n', 'czw', 'Push stash of the work tree (like czz with --keep-index)' },
  { 'n', 'czs', 'Push stash of the stage (no count)' },
  { 'n', 'czA', 'Apply topmost stash, or stash@{count}' },
  { 'n', 'cza', 'Apply topmost stash preserving the index' },
  { 'n', 'czP', 'Pop topmost stash, or stash@{count}' },
  { 'n', 'czp', 'Pop topmost stash preserving the index' },
  { 'n', 'cz<space>', 'Populate command line with ":Git stash "' },
  { 'n', 'cz?', 'Show Fugitive stash help' },

  -- Checkout and branch maps
  { 'n', 'coo', 'Check out the commit under the cursor' },
  { 'n', 'cb<space>', 'Populate command line with ":Git branch "' },
  { 'n', 'co<space>', 'Populate command line with ":Git checkout "' },
  { 'n', 'cb?', 'Show Fugitive branch help' },
  { 'n', 'co?', 'Show Fugitive checkout help' },

  -- Rebase maps
  { 'n', 'ri', 'Perform an interactive rebase using the ancestor of the commit under the cursor when available' },
  { 'n', 'rf', 'Perform an autosquash rebase without editing the todo list' },
  { 'n', 'ru', 'Perform an interactive rebase against @{upstream}' },
  { 'n', 'rp', 'Perform an interactive rebase against @{push}' },
  { 'n', 'rr', 'Continue the current rebase' },
  { 'n', 'rs', 'Skip the current commit and continue the current rebase' },
  { 'n', 'ra', 'Abort the current rebase' },
  { 'n', 're', 'Edit the current rebase todo list' },
  { 'n', 'rw', 'Perform an interactive rebase with the commit under the cursor set to `reword`' },
  { 'n', 'rm', 'Perform an interactive rebase with the commit under the cursor set to `edit`' },
  { 'n', 'rd', 'Perform an interactive rebase with the commit under the cursor set to `drop`' },
  { 'n', 'r<space>', 'Populate command line with ":Git rebase "' },
  { 'n', 'r?', 'Show Fugitive rebase help' },

  -- Diff maps
  { 'n', 'dp', 'Invoke :Git diff on the file under the cursor (deprecated in favor of inline diffs)' },
  { 'n', 'dd', 'Perform a :Gdiffsplit on the file under the cursor' },
  { 'n', 'dv', 'Perform a :Gvdiffsplit on the file under the cursor' },
  { 'n', 'ds', 'Perform a :Ghdiffsplit on the file under the cursor' },
  { 'n', 'dh', 'Perform a :Ghdiffsplit on the file under the cursor' },
  { 'n', 'dq', 'Close all but the currently focused diff buffer, and invoke :diffoff!' },
  { 'n', 'd?', 'Show Fugitive diff help' },

  -- Navigation maps
  { 'n', '[c', 'Jump to previous hunk, expanding inline diffs automatically' },
  { 'n', ']c', 'Jump to next hunk, expanding inline diffs automatically' },
  { 'n', '[/', 'Jump to previous file, collapsing inline diffs automatically' },
  { 'n', '[m', 'Jump to previous file, collapsing inline diffs automatically ("m" appears in "filenames")' },
  { 'n', ']/', 'Jump to next file, collapsing inline diffs automatically' },
  { 'n', ']m', 'Jump to next file, collapsing inline diffs automatically ("m" appears in "filenames")' },
  { 'n', '[[', 'Jump [count] sections backward' },
  { 'n', ']]', 'Jump [count] sections forward' },
  { 'n', '[]', 'Jump [count] section ends backward' },
  { 'n', '][', 'Jump [count] section ends forward' },
  { 'n', 'gu', 'Jump to file [count] in the "Untracked" or "Unstaged" section' },
  { 'n', 'gU', 'Jump to file [count] in the "Unstaged" section' },
  { 'n', 'gs', 'Jump to file [count] in the "Staged" section' },
  { 'n', 'gp', 'Jump to file [count] in the "Unpushed" section' },
  { 'n', 'gP', 'Jump to file [count] in the "Unpulled" section' },
  { 'n', 'gr', 'Jump to file [count] in the "Rebasing" section' },
  { 'n', 'gO', 'Open the file or fugitive-object under the cursor in a new vertical split' },
  { 'n', 'gI', 'Open .git/info/exclude in a split and add the file under the cursor; use a count to open .gitignore' },
  { 'n', 'gi', 'Open .git/info/exclude in a split; use a count to open .gitignore' },

  -- Misc maps
  { 'n', 'gq', 'Close the status buffer' },
  { 'n', 'g?', 'Show help for Fugitive mappings' },
}
-- stylua: ignore end

for _, map in ipairs(mappings) do
  local mode, keys, desc = unpack(map)
  MiniClue.set_mapping_desc(mode, keys, desc)
end
