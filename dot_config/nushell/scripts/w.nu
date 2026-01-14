# ~/.config/nushell/scripts/w.nu

# --- Internals ---

def w_get_base_dir [] {
  $nu.home-path | path join "dev"
}

def w_list [] {
  let base_dir = (w_get_base_dir)
  let worktrees_dir = ($base_dir | path join "worktrees")

  print "=== All Worktrees ==="
  if not ($worktrees_dir | path exists) { return }

  ls $worktrees_dir
  | where type == dir
  | each {|cat|
      let category = ($cat.name | path basename)
      ls $cat.name
      | where type == dir
      | each {|proj|
          let project = ($proj.name | path basename)
          print $""
          print $"[($category)/($project)]"
          ls $proj.name
          | where type == dir
          | each {|wt| print $"  • (($wt.name | path basename))" }
        }
    }
}

def w_rm [category: string, project: string, worktree: string] {
  let base_dir = (w_get_base_dir)
  let repo_path = ($base_dir | path join $category $project)
  let wt_path = ($base_dir | path join "worktrees" $category $project $worktree)

  if not ($wt_path | path exists) {
    error make { msg: $"Worktree not found: ($wt_path)" }
  }

  ^git -C $repo_path worktree remove $wt_path
}

def w_use [
  category: string
  project: string
  worktree: string
  command: list<string>
] {
  let base_dir = (w_get_base_dir)
  let repo_path = ($base_dir | path join $category $project)

  if not ($repo_path | path exists) {
    error make { msg: $"Project not found: ($repo_path)" }
  }

  let wt_path = ($base_dir | path join "worktrees" $category $project $worktree)

  if not ($wt_path | path exists) {
    print $"Creating new worktree: ($worktree)"
    mkdir ($base_dir | path join "worktrees" $category $project)

    let branch_name = $"($env.USER)/($worktree)"
    ^git -C $repo_path worktree add $wt_path -b $branch_name
  }

  if ($command | is-empty) {
    cd $wt_path
    return
  }

  # Execute command in worktree
  do { cd $wt_path; ^$command.0 ...($command | skip 1) }
}

# --- Completers ---

# Helper to clean context of flags so positionals match up
def w_clean_context [context: string] {
  $context | split row ' ' | where {|x| $x !~ '^-' and $x != 'w' }
}

def w_complete_categories [] {
  let base_dir = (w_get_base_dir)
  if not ($base_dir | path exists) { return [] }
  ls $base_dir | where type == dir | get name | each {|p| $p | path basename } | where {|n| $n != "worktrees" }
}

def w_complete_projects [context: string] {
  let args = (w_clean_context $context)
  let category = ($args | get 0? | default "")

  if ($category | is-empty) { return [] }

  let base_dir = (w_get_base_dir)
  let cat_dir = ($base_dir | path join $category)
  if not ($cat_dir | path exists) { return [] }

  ls $cat_dir
  | where type == dir
  | each {|d| if (($d.name | path join ".git") | path exists) { $d.name | path basename } }
}

def w_complete_worktrees [context: string] {
  let args = (w_clean_context $context)
  let category = ($args | get 0? | default "")
  let project = ($args | get 1? | default "")

  if ($project | is-empty) { return [] }

  let base_dir = (w_get_base_dir)
  let wt_root = ($base_dir | path join "worktrees" $category $project)
  if not ($wt_root | path exists) { return [] }

  ls $wt_root | where type == dir | get name | each {|p| $p | path basename }
}

# --- Main Command ---

# Git worktree manager for nested projects.
#
# Assumes git repos are at `~/dev/<category>/<project>`
# Creates worktrees at `~/dev/worktrees/<category>/<project>/<worktree>`
#
# Examples:
#   > w work myapp feature-x
#   Creates 'feature-x' worktree for 'myapp' and cd into it
#
#   > w work myapp feature-x claude
#   Runs 'claude' inside the 'feature-x' worktree
#
#   > w --list
#   Lists all active worktrees
#
#   > w --rm work myapp old-feature
#   Removes the 'old-feature' worktree
export def "w" [
  category?: string@w_complete_categories  # The category folder (e.g. 'work', 'personal')
  project?: string@w_complete_projects     # The project name (must be a git repo)
  worktree?: string@w_complete_worktrees   # The name of the worktree/branch
  ...command: string                       # Optional command to run inside the worktree
  --list                                   # List all worktrees
  --rm                                     # Remove the specified worktree
] {

  # 1. Handle --list
  if $list {
    w_list
    return
  }

  # 2. Check for required arguments
  if ($category | is-empty) or ($project | is-empty) or ($worktree | is-empty) {
     error make {
      msg: (
        "Missing arguments.\n"
        + "Usage: w <category> <project> <worktree> [command]"
      )
    }
  }

  # 3. Handle --rm
  if $rm {
    w_rm $category $project $worktree
    return
  }

  # 4. Normal Usage
  w_use $category $project $worktree $command
}
