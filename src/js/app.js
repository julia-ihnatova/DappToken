App = {
    web3Provider: null,
    contracts: {},
    account: '0x0',
    loading: false,
    tokenPrice:  1000000000000000,
    tokensSold: 0,
    tokensAvailable: 750000,
    init(){
        console.log("App initialized...");
        return App.initWeb3();
    },
    initWeb3(){
        if (typeof web3 !== 'undefined') {
            App.web3Provider = web3.currentProvider
            web3 = new Web3(web3.currentProvider);
        } else {
            // set the provider you want from Web3.providers
            App.web3Provider = new Web3.providers.HttpProvider("http://localhost:7545");
                web3 = new Web3(App.web3Provider);
        }
        // console.log(web3);
        return App.initContracts();


    },
    initContracts(){
        $.getJSON("DappTokenSale.json", function(dappTokenSale){
            App.contracts.DappTokenSale = TruffleContract(dappTokenSale);
            App.contracts.DappTokenSale.setProvider(App.web3Provider);
            App.contracts.DappTokenSale.deployed().then(function(dappTokenSale){
                console.log("Dapp Token Sale address:", dappTokenSale.address);
            });
        }).done(function(){
            $.getJSON("DappToken.json", function(dappToken){
                App.contracts.DappToken = TruffleContract(dappToken);
                App.contracts.DappToken.setProvider(App.web3Provider);
                App.contracts.DappToken.deployed().then(function(dappToken){
                    console.log("Dapp Token  address:", dappToken.address);
                });
            });
            App.listenForEvents();
            return App.render();
        })
    },

    //Listen for events emmitted from the contract
    listenForEvents(){
        App.contracts.DappTokenSale.deployed().then(function(instance){
            instance.Sell({}, {
                fromBlock: 0,
                oBlock: 'latest',
            }).watch(function(error, event){
                    console.log('Event triggered ', event);
                    App.render();
            });
        });

    },

    render(){
        if(App.loading){
            return;
        }
        App.loading = true;

        let loader = $('#loader');
        let content = $('#content');

        loader.show();
        content.hide();

        //Load account data
        web3.eth.getCoinbase(function(err, account){
            if(err === null){
                App.account = account;
                $('#account-address').html("Your Account: " + account);

            }
        });

        //Load token Sale Contract
        App.contracts.DappTokenSale.deployed().then(function(instance){
            dappTokenSaleInstance = instance;
            return dappTokenSaleInstance.tokenPrice();
        }).then(function(tokenPrice){
            App.tokenPrice = tokenPrice;
            $('.token-price').html(web3.fromWei(App.tokenPrice).toNumber());
            return dappTokenSaleInstance.tokenSold();
        }).then(function(tokenSold){
            App.tokensSold = tokenSold.toNumber();
            $('.tokens-sold').html(App.tokensSold);
            $('.tokens-available').html(App.tokensAvailable);

            let progressPercent = Math.ceil(App.tokensSold / App.tokensAvailable * 100);

            $('#progress').css('width', progressPercent + '%');

            //Load token Contract
            App.contracts.DappToken.deployed().then(function(instance){
                dappTokenInstance = instance;
                return dappTokenInstance.balanceOf(App.account);
            }).then(function(balance){
                $('.dapp-balance').html(balance.toNumber());
                App.loading = false;
                loader.hide();
                content.show();


            });

        });

    },

    buyTokens(){
        $('#content').hide();
        $('#loader').show();

        let numberOfTokens = $('#numberOfTokens').val();
        App.contracts.DappTokenSale.deployed().then(function(instance){
            return instance.buyTokens(numberOfTokens, {
                from: App.account,
                value: numberOfTokens * App.tokenPrice,
                gas: 500000
            });
        }).then(function(result){
            console.log('Tokens bought...');
            $('form').trigger('reset'); //reet number of tokens
            // $('#content').show();
            // $('#loader').hide();
            //Wait for sell event

        })
    }
}

$(function(){
    $(window).load(function(){
        App.init();
    });
});