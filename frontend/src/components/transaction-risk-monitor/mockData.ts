import type { RiskAssessment } from "./types";

export const MOCK_ASSESSMENTS: RiskAssessment[] = [
  {
    id: "716815a1-d47c-4bc4-aaa1-5f5f2ee5b059",
    time_stamp: "2026-03-03T17:11:42.116185+00:00",
    summary:
      "Transaction TX-100333 from Netherlands to United Arab Emirates with amount 16000 EUR",
    risk_level: "HIGH",
    risk_score: 85,
    risk_categories: ["AML", "Sanctions"],
    red_flags: [
      "Offshore destination",
      "Sanctions-sensitive destination",
      "New beneficiary with large transfer",
    ],
    missing_information: [],
    recommended_actions: [
      "Verify beneficiary's identity",
      "Check sanctions list for destination country",
    ],
    confidence: "HIGH",
  },
  {
    id: "a0688158-3d2b-49a8-86b1-15f52290e8ad",
    time_stamp: "2026-03-02T18:43:33.527575+00:00",
    summary:
      "Transaction TX-1003 from France to UAE with large amount and new beneficiary",
    risk_level: "HIGH",
    risk_score: 85,
    risk_categories: ["AML", "Sanctions", "Operational"],
    red_flags: [
      "Offshore destination",
      "Unusually large amount",
      "New beneficiary",
    ],
    missing_information: [],
    recommended_actions: [
      "Verify beneficiary's identity",
      "Check sanctions list",
      "Monitor transaction for suspicious activity",
    ],
    confidence: "HIGH",
  },
  {
    id: "a10ef9ff-9421-43f4-937b-1b041a38c739",
    time_stamp: "2026-02-22T16:08:03.279366+00:00",
    summary:
      "Normal transaction from a Finnish customer to a retail bank in Finland.",
    risk_level: "LOW",
    risk_score: 5,
    risk_categories: [],
    red_flags: [],
    missing_information: [],
    recommended_actions: [],
    confidence: "HIGH",
  },
  {
    id: "5564c106-f0ee-4d4b-bdda-3d80901acfa0",
    time_stamp: "2026-02-22T16:07:59.174812+00:00",
    summary:
      "Normal transaction from a Finnish customer to a retail bank in Finland.",
    risk_level: "LOW",
    risk_score: 5,
    risk_categories: [],
    red_flags: [],
    missing_information: [],
    recommended_actions: [],
    confidence: "HIGH",
  },
  {
    id: "7b99dfb4-bd1f-489e-a5b0-f08b2d3c835b",
    time_stamp: "2026-02-19T18:05:17.953128+00:00",
    summary:
      "Transaction from Germany to Cayman Islands with large amount and offshore destination",
    risk_level: "HIGH",
    risk_score: 90,
    risk_categories: ["AML", "Sanctions", "Operational"],
    red_flags: ["Offshore destination", "Large amount", "New beneficiary"],
    missing_information: [],
    recommended_actions: [
      "Verify customer identity and purpose of transfer",
      "Monitor transaction for potential money laundering",
    ],
    confidence: "HIGH",
  },
];
