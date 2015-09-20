//
//  AKMoogLadder.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** Moog Ladder Filter

Moog Ladder is an new digital implementation of the Moog ladder filter based on the work of Antti Huovilainen, described in the paper "Non-Linear Digital Implementation of the Moog Ladder Filter" (Proceedings of DaFX04, Univ of Napoli). This implementation is probably a more accurate digital representation of the original analogue filter.
*/
@objc class AKMoogLadder : AKParameter {

    // MARK: - Properties

    private var moogladder = UnsafeMutablePointer<sp_moogladder>.alloc(1)
    private var moogladder2 = UnsafeMutablePointer<sp_moogladder>.alloc(1)

    private var input = AKParameter()


    /** Filter cutoff frequency. [Default Value: 1000] */
    var cutoffFrequency: AKParameter = akp(1000) {
        didSet {
            cutoffFrequency.bind(&moogladder.memory.freq, right:&moogladder2.memory.freq)
            dependencies.append(cutoffFrequency)
        }
    }

    /** Resonance, generally < 1, but not limited to it. Higher than 1 resonance values might cause aliasing, analogue synths generally allow resonances to be above 1. [Default Value: 0.5] */
    var resonance: AKParameter = akp(0.5) {
        didSet {
            resonance.bind(&moogladder.memory.res, right:&moogladder2.memory.res)
            dependencies.append(resonance)
        }
    }


    // MARK: - Initializers

    /** Instantiates the filter with default values

    - parameter input: Input audio signal. 
    */
    init(input: AKParameter)
    {
        super.init()
        self.input = input
        setup()
        dependencies = [input]
        bindAll()
    }

    /** Instantiates the filter with all values

    - parameter input: Input audio signal. 
    - parameter cutoffFrequency: Filter cutoff frequency. [Default Value: 1000]
    - parameter resonance: Resonance, generally < 1, but not limited to it. Higher than 1 resonance values might cause aliasing, analogue synths generally allow resonances to be above 1. [Default Value: 0.5]
    */
    convenience init(
        input:           AKParameter,
        cutoffFrequency: AKParameter,
        resonance:       AKParameter)
    {
        self.init(input: input)
        self.cutoffFrequency = cutoffFrequency
        self.resonance       = resonance

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        cutoffFrequency.bind(&moogladder.memory.freq, right:&moogladder2.memory.freq)
        resonance      .bind(&moogladder.memory.res, right:&moogladder2.memory.res)
        dependencies.append(cutoffFrequency)
        dependencies.append(resonance)
    }

    /** Internal set up function */
    internal func setup() {
        sp_moogladder_create(&moogladder)
        sp_moogladder_create(&moogladder2)
        sp_moogladder_init(AKManager.sharedManager.data, moogladder)
        sp_moogladder_init(AKManager.sharedManager.data, moogladder2)
    }

    /** Computation of the next value */
    override func compute() {
        sp_moogladder_compute(AKManager.sharedManager.data, moogladder, &(input.leftOutput), &leftOutput);
        sp_moogladder_compute(AKManager.sharedManager.data, moogladder2, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_moogladder_destroy(&moogladder)
        sp_moogladder_destroy(&moogladder2)
    }
}
