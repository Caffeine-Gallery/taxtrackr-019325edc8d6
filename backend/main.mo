import Array "mo:base/Array";
import Bool "mo:base/Bool";

import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Option "mo:base/Option";

actor {
    // Define the TaxPayer type
    public type TaxPayer = {
        tid: Text;
        firstName: Text;
        lastName: Text;
        address: Text;
    };

    // Create stable storage for upgrades
    private stable var taxpayersEntries : [(Text, TaxPayer)] = [];
    
    // Initialize HashMap for taxpayers
    private var taxpayers = HashMap.HashMap<Text, TaxPayer>(0, Text.equal, Text.hash);

    // System functions for upgrade persistence
    system func preupgrade() {
        taxpayersEntries := Iter.toArray(taxpayers.entries());
    };

    system func postupgrade() {
        taxpayers := HashMap.fromIter<Text, TaxPayer>(taxpayersEntries.vals(), 1, Text.equal, Text.hash);
        taxpayersEntries := [];
    };

    // Add a new taxpayer
    public func addTaxPayer(tp: TaxPayer) : async Bool {
        if (Option.isSome(taxpayers.get(tp.tid))) {
            return false; // TID already exists
        };
        taxpayers.put(tp.tid, tp);
        return true;
    };

    // Get a taxpayer by TID
    public query func getTaxPayer(tid: Text) : async ?TaxPayer {
        taxpayers.get(tid)
    };

    // Get all taxpayers
    public query func getAllTaxPayers() : async [TaxPayer] {
        Iter.toArray(taxpayers.vals())
    };
}
