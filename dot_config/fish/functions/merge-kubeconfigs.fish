function merge-kubeconfigs
    set kube_configs_dir ~/.kube/configs
    set kube_config ~/.kube/config

    # Initialize arrays to store the JSON of each config file
    set clusters_json (jq -n '[]')
    set contexts_json (jq -n '[]')
    set users_json (jq -n '[]')

    for file in $kube_configs_dir/config.*
        # Extract the identifier from the file name (e.g., 'aws' from 'config.aws')
        set identifier (basename $file | sed 's/config.//')

        # Load the entire JSON
        set config_json (kubectl --kubeconfig $file config view --flatten -o json)

        # Update cluster, context, and user names based on the identifier
        set config_json (echo $config_json | jq --arg id "$identifier" '(.clusters[].name) |= $id')
        set config_json (echo $config_json | jq --arg id "$identifier" '(.contexts[].name) |= $id')
        set config_json (echo $config_json | jq --arg id "$identifier" '(.contexts[].context.cluster) |= $id')
        set config_json (echo $config_json | jq --arg id "$identifier" '(.contexts[].context.user) |= $id')
        set config_json (echo $config_json | jq --arg id "$identifier" '(.users[].name) |= $id')

        # Temporary variables for clusters, contexts, and users
        set temp_clusters (echo $config_json | jq '.clusters')
        set temp_contexts (echo $config_json | jq '.contexts')
        set temp_users (echo $config_json | jq '.users')

        # Merge the modified sections into the respective arrays
        set clusters_json (echo $clusters_json | jq --argjson newClusters "$temp_clusters" '. + $newClusters')
        set contexts_json (echo $contexts_json | jq --argjson newContexts "$temp_contexts" '. + $newContexts')
        set users_json (echo $users_json | jq --argjson newUsers "$temp_users" '. + $newUsers')
    end

    # Construct the final config JSON object
    set final_json (jq -n \
        --argjson clusters "$clusters_json" \
        --argjson contexts "$contexts_json" \
        --argjson users "$users_json" \
        --arg currentContext (echo $contexts_json | jq -r '.[-1].name') \
        '{
            "apiVersion": "v1",
            "kind": "Config",
            "clusters": $clusters,
            "contexts": $contexts,
            "current-context": $currentContext,
            "users": $users,
            "preferences": {}
         }')

    # Write the final JSON to the kube config file
    echo $final_json > $kube_config

    echo "Merged config has been written to $kube_config"
end
