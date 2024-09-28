#!/bin/bash

curl -s https://raw.githubusercontent.com/zunxbt/logo/main/logo.sh | bash
sleep 3

show() {
    echo -e "\033[1;34m$1\033[0m"
}

source <(wget -O - https://raw.githubusercontent.com/zunxbt/installation/main/rust.sh)

install_solana() {
    if ! command -v solana &> /dev/null; then
        show "Solana not found. Installing Solana..."
        # Install Solana using the official installer
        sh -c "$(curl -sSfL https://release.solana.com/v1.18.18/install)"
    else
        show "Solana is already installed."
    fi

    if ! grep -q "$HOME/.local/share/solana/install/active_release/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
        show "Added Solana to PATH in .bashrc."
    fi

    if [ -n "$ZSH_VERSION" ]; then
        if ! grep -q "$HOME/.local/share/solana/install/active_release/bin" ~/.zshrc; then
            echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.zshrc
            show "Added Solana to PATH in .zshrc."
        fi
    fi

    if [ -n "$BASH_VERSION" ]; then
        source ~/.bashrc
    elif [ -n "$ZSH_VERSION" ]; then
        source ~/.zshrc
    fi

    export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
    if command -v solana &> /dev/null; then
        show "Solana is available in the current session."
    else
        show "Failed to add Solana to the PATH. Exiting."
        exit 1
    fi
}

setup_wallet() {
    KEYPAIR_DIR="$HOME/solana_keypairs"
    mkdir -p "$KEYPAIR_DIR"

    show "Do you want to use an existing wallet or create a new one?"
    PS3="Please enter your choice (1 or 2): "
    options=("Use existing wallet" "Create new wallet")
    select opt in "${options[@]}"; do
        case $opt in
            "Use existing wallet")
                show "Recovering from existing wallet..."
                KEYPAIR_PATH="$KEYPAIR_DIR/eclipse-import.json"
                solana-keygen recover -o "$KEYPAIR_PATH" --force
                if [[ $? -ne 0 ]]; then
                    show "Failed to recover the existing wallet. Exiting."
                    exit 1
                fi
                break
                ;;
            "Create new wallet")
                show "Creating a new wallet..."
                KEYPAIR_PATH="$KEYPAIR_DIR/eclipse-new.json"
                solana-keygen new -o "$KEYPAIR_PATH" --force
                if [[ $? -ne 0 ]]; then
                    show "Failed to create a new wallet. Exiting."
                    exit 1
                fi
                break
                ;;
            *) show "Invalid option. Please try again." ;;
        esac
    done

    solana config set --keypair "$KEYPAIR_PATH"
    show "Wallet setup completed!"
}

setup_network() {
    show "Do you want to deploy on the mainnet or testnet?"
    PS3="Please enter your choice (1 or 2): "
    network_options=("Mainnet" "Testnet")
    select network_opt in "${network_options[@]}"; do
        case $network_opt in
            "Mainnet")
                show "Setting to Mainnet..."
                NETWORK_URL="https://mainnetbeta-rpc.eclipse.xyz"
                break
                ;;
            "Testnet")
                show "Setting to Testnet..."
                NETWORK_URL="https://testnet.dev2.eclipsenetwork.xyz"
                break
                ;;
            *) show "Invalid option. Please try again." ;;
        esac
    done

    show "Setting Solana config..."
    solana config set --url "$NETWORK_URL"
    
    show "Network setup completed!"
}


create_spl_and_operations() {
    show "Creating SPL token..."

    if ! solana config get | grep -q "Keypair Path:"; then
        show "Error: No keypair is set in Solana config. Exiting."
        exit 1
    fi

    spl-token create-token --enable-metadata -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb
    if [[ $? -ne 0 ]]; then
        show "Failed to create SPL token. Exiting."
        exit 1
    fi

    read -p "Enter the token address you found above: " TOKEN_ADDRESS
    read -p "Enter your token symbol (e.g., ZUNXBT): " TOKEN_SYMBOL
    read -p "Enter your token name (e.g., Zenith Token): " TOKEN_NAME
    read -p "Enter your token metadata url: " METADATA_URL

    show "Initializing token metadata..."
    spl-token initialize-metadata "$TOKEN_ADDRESS" "$TOKEN_NAME" "$TOKEN_SYMBOL" "$METADATA_URL"
    if [[ $? -ne 0 ]]; then
        show "Failed to initialize token metadata. Exiting."
        exit 1
    fi

    show "Creating token account..."
    spl-token create-account "$TOKEN_ADDRESS"
    if [[ $? -ne 0 ]]; then
        show "Failed to create token account. Exiting."
        exit 1
    fi

    show "Minting tokens..."
    spl-token mint "$TOKEN_ADDRESS" 10000
    if [[ $? -ne 0 ]]; then
        show "Failed to mint tokens. Exiting."
        exit 1
    fi

    show "Token operations completed successfully!"
}


main_menu() {
    while true; do
        show "Select a part to execute:"
        PS3="Please enter your choice (1, 2, 3, 4, or 5): "
        options=("Installation" "Wallet Setup" "Network Setup" "Create SPL Token and Operations" "Exit")
        select opt in "${options[@]}"; do
            case $opt in
                "Installation")
                    install_solana
                    ;;
                "Wallet Setup")
                    setup_wallet
                    ;;
                "Network Setup")
                    setup_network
                    ;;
                "Create SPL Token and Operations")
                    create_spl_and_operations
                    ;;
                "Exit")
                    show "Exiting the script."
                    exit 0
                    ;;
                *) show "Invalid option. Please try again." ;;
            esac
            break
        done
    done
}


main_menu
