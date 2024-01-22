# building an event management and creation dapp.
    1. Filecoin & IPFS
    2. The Graph
    3. Radicle
    4. Infura
    5. Polygon
    6. Lens

# blockchain
    The blockchain is an expanding system that records information in a manner that makes it hard or almost impossible to hack the system. Information gets recorded in blocks, which are like little lists of records.

# How do blockchain transactions work
    Transactions are requests for your action to be validated and added to the chain. In order to successfully execute a transaction on the Blockchain, a gas fee (a transaction fee on the blockchain) is typically required.

    When there is a lot of traffic and there is high demand for the network, the gas fees go up because block space is limited, and therefore miners can demand higher fees in order to prioritize which transactions they want to process. Think of it like Uber Surge Pricing: if you're at an airport with a bunch of people getting Ubers, the prices go up and the wait times go up.    

    Gas fees are something that all users must pay in order to perform a function on the blockchain. The amount of gas required to pay varies depending on which blockchain you’re using, as well as other factors like high traffic. According to Gemini, the amount of these transaction fees can vary from less than 0.0001 USD to over 100 USD.

    Once the transaction has been requested, it gets authenticated and added to a block (which represents a set of transactions across the blockchain). These blocks each have a maximum storage capacity so that once the capacity is reached, the blocks are closed and linked to the previously filled block. Also, these blocks contain information like digital signatures, a timestamp, and any other important information. The block is sent out to the entirety of the network’s nodes (participants on the blockchain).

    After, nodes validate the transaction and then receive a reward (usually, the reward will be that blockchain’s main cryptocurrency) for participating in the validation process. Then, the block gets officially added to the existing blockchain. Afterward, the blockchain receives an update across the entire network and officially reflects that transaction. The transaction is now complete.

# Smart Contracts
    A smart contract is a computer program compiled from code that can control events and actions according to the terms set within the contract’s code.

    Smart contracts can be programmed to accept payment and can return an item in place of that payment. An example of this would be a “mint” button on a project’s website. Minting is the process of taking a digital asset like a photo and publishing that asset to the blockchain. Many NFT projects with a minting website will have a smart contract designed so that whenever the buyer pays a specified fee, they can “mint” a project’s NFT. Then, the smart contract activates the function that accepts the buyer’s payment and follows that function up with another one that distributes a randomly-generated NFT to the buyer.

    In another example, some websites allow you to swap one cryptocurrency into a different one. Popular sites like Uniswap have options to swap between many different cryptocurrencies. Each time a user goes to execute a swap, a function tied to a smart contract is triggered. Like the vending machine, the swapping smart contract accepts the user’s payment and then sends the user the currency they requested in return.

# Crypto Wallets
    A crypto wallet is a storage system for your digital assets like cryptocurrencies, NFTs, and more. The contents of each crypto wallet can be accessed by a unique key made of a combination of letters and numbers explicitly assigned to the wallet’s creator (called a private key).

    A crypto wallet’s public key is the public address of the user’s wallet. Think of it as a business address available publicly on the web. Anyone can use a wallet’s public key to look up and verify transaction information, however, personal information is not posted to the blockchain.

# Client Server Architecture
    A client application is the one that a user is actually interacting with, that's displaying the content. A server application is the one that sends the content, or resource, to your client application. A server application is a program that is running somewhere, listening, and waiting for a request.

    The main reason for this separation is to secure sensitive information. Your entire client application gets downloaded into the browser, and all of the data can be accessed by anyone accessing your web page.

    Instead of having a server application, blockchain developers have this idea of open and composable backends, AKA smart contracts. You'll create a smart contract which handles the logic for the creation of a new event, RSVP'ing to a new event, etc. Your client application will be in charge of aggregating and displaying all of the events that were created, show a dashboard to your user indicating past and upcoming events, etc.

# scaling solutions
    Ethereum has become one of the most popular blockchains for a while due to its ability to employ Turing complete smart-contracts. Though, after it gained popularity there has been a significant network congestion resulting in high gas fees.

    L1 Blockchain refers to the main blockchain layer such as Ethereum. Layer1 scaling solutions are implemented directly on the main blockchain, thus deriving the name on-chain solutions. Some examples of the on-chain scaling solution involve Consensus Protocol Switch and Sharding.

    L2 Blockchains are add-on solutions built on the base layer. Thus deriving the name off-chain scaling solution, since they intend to take away workload from the blockchain while utilizing its security.

    Sidechains are Ethereum-compatible independent blockchains with their own consensus model. Sidechains achieve interoperability with Ethereum by the use of the same EVM. Since they are independent from the main-chain, side chains are responsible for their own security. If a sidechain’s security is compromised, it will pose no impact to the mainchain.

    Polygon is a scaling solution that achieves scale by utilizing sidechains for off-chain computation and a decentralized network of Proof-of-Stake (PoS) validators.
    Polygon strives to solve the scalability and usability issues while not compromising on decentralization and leveraging the existing developer community and ecosystem.

    Ethereum can be slow and costly. Sidechains such as Polygon were created as a solution to speed up the blockchain while making minimal sacrifices on security and decentralization thus an improved user experience and reduced network congestion.

# full-stack RSVP dapp
    Here’s what our smart contract should be able to handle:
        # Creation of a new event:        
        1. A unique ID
        2. A reference to who created the event (a wallet address of the creator)
        3. The time of the event, so we know when refunds should become available.
        4. The maximum capacity of attendees for that event
        5. The deposit amount for that event
        6. Keep track of those who RSVP’d
        7. Keep track of users who check into the event
        8. Find the difference between those who RSVP’d and those who checked in, and refund everyone except those.

        # RSVP to an event:
        1. Pass in a unique event ID the user wishes to RSVP to
        2. Ensure that the value of their deposit is sufficient for that event’s deposit requirement
        3. Ensure that the event hasn’t already started based on the timestamp of the event - people shouldn’t be able to RSVP after the event has started
        4. Ensure that the event is under max capacity

        # Check in attendees:
        1. Pass a unique event ID for the event the user wants to confirm users for
        2. Ensure that only the creator of the event can confirm attendees
        3. Pass in the attendee address of the user who is checking in and check if their address is saved in RSVP list
        4. If they are found in the RSVP list, add them to a list of confirmed attendees
        5. If user is in the confirmed attendees list, return their deposit

        # Withdraw any remaining deposits from guests who didn’t check in and send them to the owner of the event:
        1. Pass in a unique event ID for the event the user wishes to withdraw funds from
        2. Ensure that at least 7 days have passed since the event
        3. Find the difference in the number of guests who rsvp’d and guests who checked in
        4. Multiply the deposit amount times the discrepancy of guests between rsvp and check in and send the amount back to the owner

# subgraphs
    We'll be diving into the specifics of building our subgraph after the smart contract section, but you should understand the role of a subgraph in your dapp as you're writing the smart contract to make sure that you're optimizing your contract for the on-chain information you want to show on your front end

    Recall that Solidity events are a way for our subgraph to listen for specific actions to enable us to make queries about the data from our smart contract

# deploying with infura
    Infura is a company that provides web3 infrastructure tools that allow developers to develop on a blockchain. Infura provides the nodes that are the entry point to the blockchain and allow you to execute transactions. Without a node provider like Infura, a developer would have to run their own node to communicate with the blockchain, which can be expensive, difficult, and time consuming.

    
# graph
    The Graph is a web3 protocol that allows developers to create GraphQL APIs to query data from any smart contract. This makes it fast and easy to create dashboards and websites that show live data about how users are interacting with your contract.

    Anyone can deploy their own API, also called a subgraph. Our subgraph will allow us to connect our frontend website to our contract so we can easily fetch the data we need.

    Without The Graph, developers had to run their own indexing servers to be able to query their smart contract data. This can be expensive to run, and because it’s a centralized server it could be vulnerable to down-time and censorship.

    You can use The Graph’s hosted service for free with any chain. You can find a full list here. You can also use The Graph’s decentralized network for subgraphs that index Ethereum mainnet contracts, which charges a small fee for each query. For this tutorial, we will be using the free hosted service.

