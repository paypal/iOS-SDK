//
//  File.swift
//  
//
//  Created by Karthik Gangineni on 5/25/22.
//

import Foundation

class EligibilityAPI{
    private var graphQLClient: GraphQLClient
    private var coreConfig: CoreConfig
    init(coreConfig: CoreConfig){
        self.coreConfig = coreConfig
        graphQLClient = GraphQLClient(environment: coreConfig.environment)
    }
    
    func checkEligibility() async throws -> APIResult<Eligibility>{
        let fundingEligibilityQuery = FundingEligibilityQuery(clientId: coreConfig.clientID, fundingEligibilityIntent: FundingEligibilityIntent.CAPTURE, currencyCode: SupportedCountryCurrencyType.USD, enableFunding: [SupportedPaymentMethodsType.VENMO])
        let response: GraphQLQueryResponse<FundingEligibilityResponse> = try await graphQLClient.executeQuery(query: fundingEligibilityQuery)
        if(response.data==nil) {
            return APIResult.failure(GraphQLError(message: "error fetching eligibility", extensions: nil))
        }
        else{
            return APIResult.success(Eligibility(isVenmoEligible: response.data?.fundingEligibility.venmo.eligible ?? false, isPaypalEligible: response.data?.fundingEligibility.paypal.eligible ?? false, isPaypalCreditEligible: response.data?.fundingEligibility.credit.eligible ?? false, isPayLaterEligible: response.data?.fundingEligibility.payLater.eligible ?? false, isCreditCardEligible: response.data?.fundingEligibility.card.eligible ?? false))
            
        }
    }
    
}
