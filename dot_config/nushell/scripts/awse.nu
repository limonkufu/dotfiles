export def --env main [profile: string] {
  let creds = (
    aws-vault export --format=ini $profile
    | from ini
    | get $profile
    | items { |k, v| { key: ($k | str upcase), value: $v } }
    | reduce -f {} { |r, acc|
        $acc | upsert $r.key $r.value
      }
  )

  $creds
  | upsert AWS_REGION ($creds.REGION?)
  | upsert AWS_DEFAULT_REGION ($creds.REGION?)
  | reject REGION
  | load-env
}
