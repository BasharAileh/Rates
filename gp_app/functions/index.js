const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");

initializeApp();

const db = getFirestore();

exports.calculateAndUpdate = onDocumentWritten(
  { document: "product_rating/{docId}" },
  async (event) => {
    try {
      const snapshot = await db.collection("product_rating").get();
      let shop = "";

      // Using for...of instead of forEach for async/await support
      for (const doc of snapshot.docs) {
        const data = doc.data();

        // Iterate over the keys of the data
        for (const key of Object.keys(data)) {
          if (key === "shop_id") {
            // Use the key dynamically when setting the document
            await db.collection("shop").doc("nar_snack").set(
              {
                [key]: data[key], // Dynamic key value
              },
              { merge: true }
            );
          }
        }
      }

      console.log("Target collection updated successfully.");
    } catch (error) {
      console.error("Error updating target collection:", error);
    }
  }
);
