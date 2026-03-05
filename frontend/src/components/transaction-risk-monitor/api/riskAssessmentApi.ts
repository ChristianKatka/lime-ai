import type { RiskAssessment } from "../types";
import { API_BASE_URL } from "../../../config";

export const fetchRiskAssessments = async (): Promise<RiskAssessment[]> => {
  try {
    const response = await fetch(`${API_BASE_URL}/risk`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error fetching risk assessments:", error);
    throw error;
  }
};

export const submitTransaction = async (
  transactionData: unknown,
): Promise<void> => {
  try {
    const response = await fetch(`${API_BASE_URL}/transaction`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(transactionData),
    });
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
  } catch (error) {
    console.error("Error submitting transaction:", error);
    throw error;
  }
};
