pragma experimental ABIEncoderV2;
pragma solidity >=0.4.22 <= 0.6.11;


contract Storage {


    struct ModelParameter{

        address owner;
        string modelParameter;
    }


    uint fedStep;

    address[] activateClients;

    address[] selectedClients;

    address[] distilledClients;
    // fed step -> model parameters
    mapping(uint => ModelParameter[]) modelParameters;

    // fed step -> selected client address
    mapping(uint => address) selectedAddress;

    // fed step -> aggregated model parameters
    mapping(uint => ModelParameter) aggregatedParameters;

    string final_aggregated_model_parameters;

    function __addressValidation() private view returns(bool) {

        for(uint i=0; i<activateClients.length; i++){
            if(msg.sender == activateClients[i]){
                return true;
            }
        }

        return false;
    }

    function setFedStep(uint _fedStep) public {
        fedStep = _fedStep;
    }

    function getFedStep() public view returns (uint) {
        return fedStep;
    }

    function updateActivateClients(uint8 op) public {

        uint sym = 0;
        bool isHave = false;
        for(uint i=0; i<activateClients.length; i++){
            if(msg.sender == activateClients[i]){
                isHave = true;
                sym = i;
                break;
            }
        }
        if(!isHave && op == 0){
            activateClients.push(msg.sender);
        }else if(isHave  && op == 1){
            activateClients[sym] = activateClients[activateClients.length - 1];
            delete activateClients[activateClients.length - 1];

        }

    }

    function uploadModelParametersIpfsHash(uint _fedStep, address _clientAddress, string memory _modelParsIpfsHash) public {
        require(__addressValidation())
        if(selectedClients.length * 2 >= activateClients.length) {
            distilledClients[_fedStep] = selectionClientAddress()
            ModelParameter memory modelParameter = ModelParameter(msg.sender, _modelParsIpfsHash);

            modelParameters[_fedStep].push(modelParameter);
        }
        
    }

    function downloadModelParametersIpfsHash(uint _fedStep, address _clientAddress) public view returns(ModelParameter[] memory) {
        require(__addressValidation())

        return modelParameters[_fedStep];

    }
    function uploadAggreagtedParametersIpfsHash(uint _fedStep, address _modelClientAddress, string memory _aggregatedModelParsIpfsHash) public {
        require(__addressValidation())
        ModelParameter memory modelParameter = ModelParameter(msg.sender, _aggregatedModelParsIpfsHash);

        aggregatedParameters[_fedStep] = modelParameter;

    }

    function downloadAggreagtedParametersIpfsHash(uint _fedStep) public view returns(ModelParameter memory){
        require(__addressValidation())
        return aggregatedParameters[_fedStep];
    }


    function uploadFinalAggregatedParametersIpfsHash(string memory _finalAggregatedIpfsHash) public {
        require(__addressValidation())
        final_aggregated_model_parameters = _finalAggregatedIpfsHash;
    }


    function downloadFinalAggregatedParametersIpfsHash() public view returns (string memory) {
        require(__addressValidation())
        return final_aggregated_model_parameters;
    }

    function selectionClientAddress() public view returns (string memory) {
        uint random = uint(keccak256(msg.sender, now))) % activateClients.length;
        return activateClients[random] 
    }

}