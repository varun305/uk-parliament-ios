import Foundation

class Mocks {
    static public private(set) var mockBill = try! JSONDecoder().decode(Bill.self, from: """
{
  "longTitle": "A Bill to require local authorities to designate high streets in their area; to require local authorities to undertake and publish periodic reviews of the condition of those high streets; to require local authorities to develop action plans for the improvement of the condition of those high streets; and for connected purposes.",
  "summary": null,
  "sponsors": [
    {
      "member": {
        "memberId": 4643,
        "name": "Jack Brereton",
        "party": "Conservative",
        "partyColour": "0000ff",
        "house": "Commons",
        "memberPhoto": "https://members-api.parliament.uk/api/Members/4643/Thumbnail",
        "memberPage": "https://members.parliament.uk/member/4643/contact",
        "memberFrom": "Stoke-on-Trent South"
      },
      "organisation": null,
      "sortOrder": 1
    }
  ],
  "promoters": [],
  "petitioningPeriod": null,
  "petitionInformation": null,
  "agent": null,
  "billId": 3548,
  "shortTitle": "High Streets (Designation, Review and Improvement Plan) Bill",
  "currentHouse": "Commons",
  "originatingHouse": "Commons",
  "lastUpdate": "2024-03-12T23:17:31.2836411",
  "billWithdrawn": null,
  "isDefeated": false,
  "billTypeId": 7,
  "introducedSessionId": 38,
  "includedSessionIds": [
    38
  ],
  "isAct": false,
  "currentStage": {
    "id": 18467,
    "stageId": 8,
    "sessionId": 38,
    "description": "Committee stage",
    "abbreviation": "CS",
    "house": "Commons",
    "stageSittings": [
      {
        "id": 15578,
        "stageId": 8,
        "billStageId": 18467,
        "billId": 3548,
        "date": "2024-03-13T00:00:00"
      }
    ],
    "sortOrder": 4
  }
}
""".data(using: .utf8)!)
}
