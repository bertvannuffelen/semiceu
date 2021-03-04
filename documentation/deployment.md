To initiate the binding between the publication repository (configuration) and its resulting repository (generated) keys have to be initiated.
The objective of this configuration is that a commit on this repository will lead to a commit on the generated repository. 
To chain them together a trust is created using keys.

Follow the instructions at https://circleci.com/docs/2.0/gh-bb-integration/#creating-a-github-deploy-key

In short the following actions have to be done:

1. create a ssh key-pair (Private/Public) for the publication environment best use as identify the email specified in config/ontology.defaults.
2. activate a deploy key on the generated repository with write access using the public key
     github repo > Settings > Deploy key
3. activate the private key for the circleci project
     circleci project > Project Settings > SSH Keys > Addition SSH Keys 
     
     hostname: github.com
     key: Private key

4. copy the fingerprint of the key at the right place in the .circleci/config.yml file



More background reading

- https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
- https://circleci.com/docs/2.0/add-ssh-key/
- https://circleci.com/docs/2.0/gh-bb-integration/
