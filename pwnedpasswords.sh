#!/bin/bash
# Check password against pwnedpasswords.com API to see if password has been reported as compromised - christopher.sargent@sargentwalker.io 09042023

candidate_password=$1

echo "Candidate password: $candidate_password"
full_hash=$(echo -n "$candidate_password" | sha1sum | awk '{print substr($1, 0, 40)}')
prefix=$(echo "$full_hash" | awk '{print substr($1, 0, 5)}')
suffix=$(echo "$full_hash" | awk '{print substr($1, 6, 35)}')

if curl -s "https://api.pwnedpasswords.com/range/$prefix" | grep -i "$suffix"; then
    echo "Candidate password is compromised"
else
    echo "Candidate password is OK for use"
fi
