/**
 * htmFX 200+ Spatial FX & Particle Emitters Catalogue (.fx)
 * Comprehensive taxonomy of 200+ physics and particle effects.
 */

export interface ParticleEffectDescriptor {
  name: string;
  category: 'thermal' | 'electric' | 'fluid' | 'kinetic' | 'cosmic' | 'atmospheric';
  color: [number, number, number, number];
  rate: number;
  initialSpeed: number;
  speedSpread: number;
  gravityFactor: number;
  dragFactor: number;
  lifetimeSec: number;
  turbulence: number;
  blendMode: 'additive' | 'alpha';
  description: string;
}

export const SPATIAL_FX_CATALOGUE: Record<string, ParticleEffectDescriptor> = {};

// Helper to register effects concisely
function reg(
  name: string,
  category: ParticleEffectDescriptor['category'],
  color: [number, number, number, number],
  rate: number,
  initialSpeed: number,
  speedSpread: number,
  gravityFactor: number,
  dragFactor: number,
  lifetimeSec: number,
  turbulence: number,
  blendMode: 'additive' | 'alpha',
  description: string
) {
  SPATIAL_FX_CATALOGUE[name.toLowerCase()] = {
    name,
    category,
    color,
    rate,
    initialSpeed,
    speedSpread,
    gravityFactor,
    dragFactor,
    lifetimeSec,
    turbulence,
    blendMode,
    description
  };
}

// -------------------------------------------------------------
// 1. THERMAL / COMBUSTION / PLASMA (40 FX)
// -------------------------------------------------------------
reg('burn', 'thermal', [1.0, 0.4, 0.05, 0.9], 800, 4.5, 1.5, -2.5, 0.05, 2.0, 0.8, 'additive', 'Upward buoyant combustion flame with thermal plume turbulence');
reg('flare', 'thermal', [1.0, 0.8, 0.2, 1.0], 1500, 12.0, 4.0, -1.0, 0.1, 1.2, 1.2, 'additive', 'High-intensity incandescent magnesium flare with spark trail');
reg('inferno', 'thermal', [1.0, 0.2, 0.0, 0.95], 2500, 8.0, 3.0, -4.0, 0.08, 2.8, 1.5, 'additive', 'Raging vortex inferno with swirling thermal convective column');
reg('plasma_torch', 'thermal', [0.2, 0.7, 1.0, 1.0], 1200, 25.0, 2.0, 0.0, 0.02, 0.6, 0.3, 'additive', 'High-velocity focused thermal plasma cutting jet');
reg('napalm', 'thermal', [0.95, 0.45, 0.1, 0.85], 1000, 6.0, 2.0, 3.0, 0.15, 4.0, 0.6, 'additive', 'Sticky burning liquid fuel droplets with ground clinging');
reg('cinder', 'thermal', [1.0, 0.5, 0.1, 0.7], 400, 2.0, 1.0, -0.5, 0.04, 3.5, 0.9, 'additive', 'Slow-drifting glowing ember flakes rising in convection');
reg('magma', 'thermal', [0.9, 0.25, 0.05, 0.95], 600, 3.0, 1.0, 9.8, 0.3, 3.0, 0.2, 'alpha', 'Viscous dripping molten rock with hardening dark crust');
reg('solar_flare', 'thermal', [1.0, 0.9, 0.4, 0.95], 3000, 40.0, 15.0, 0.0, 0.01, 2.5, 2.0, 'additive', 'Coronal magnetic mass ejection with helical twist');
reg('afterburner', 'thermal', [0.3, 0.6, 1.0, 0.95], 2000, 50.0, 5.0, 0.0, 0.05, 0.4, 0.4, 'additive', 'Supersonic jet exhaust shock diamonds');
reg('thermite', 'thermal', [1.0, 1.0, 0.8, 1.0], 1800, 10.0, 8.0, 9.8, 0.05, 1.5, 1.8, 'additive', 'White-hot molten iron sparks spraying with high velocity');
reg('bonfire', 'thermal', [1.0, 0.35, 0.05, 0.85], 600, 3.5, 1.2, -2.0, 0.06, 2.5, 0.7, 'additive', 'Natural wood fire with crackling micro-embers');
reg('candle_flicker', 'thermal', [1.0, 0.7, 0.2, 0.9], 150, 0.8, 0.2, -0.8, 0.08, 1.2, 0.3, 'additive', 'Subtle laminar candle flame with gentle waver');
reg('dragon_breath', 'thermal', [1.0, 0.15, 0.0, 1.0], 3500, 30.0, 6.0, -1.0, 0.08, 1.8, 2.2, 'additive', 'Massive horizontal conic torrent of mythological fire');
reg('flamethrower', 'thermal', [0.98, 0.5, 0.1, 0.9], 2200, 26.0, 4.0, 2.0, 0.12, 1.4, 1.6, 'additive', 'Pressurized liquid gas stream atomizing into rolling fireballs');
reg('magma_geyser', 'thermal', [0.95, 0.3, 0.0, 1.0], 1400, 18.0, 5.0, 9.8, 0.1, 2.4, 1.0, 'additive', 'Vertical volcanic eruption column of basaltic lava');
reg('forge_sparks', 'thermal', [1.0, 0.85, 0.4, 1.0], 1100, 14.0, 7.0, 9.8, 0.03, 0.8, 1.4, 'additive', 'High-speed tangential sparks bouncing off anvil');
reg('fusion_core', 'thermal', [0.3, 0.8, 1.0, 1.0], 4000, 10.0, 2.0, 0.0, 0.0, 5.0, 0.8, 'additive', 'Tokamak magnetic containment plasma core');
reg('reactor_meltdown', 'thermal', [0.2, 1.0, 0.4, 0.9], 3000, 15.0, 8.0, -1.5, 0.05, 3.0, 2.5, 'additive', 'Cherenkov radiation glow combined with superheated radioactive steam');
reg('meteor_trail', 'thermal', [1.0, 0.6, 0.2, 0.9], 2500, 60.0, 5.0, 0.5, 0.02, 1.5, 0.8, 'additive', 'Hypersonic atmospheric ablation wake');
reg('rocket_exhaust', 'thermal', [1.0, 0.8, 0.4, 0.95], 3200, 55.0, 4.0, 0.0, 0.04, 0.7, 0.5, 'additive', 'Heavy-lift rocket kerosene/LOX thrust plume');
reg('plasma_grenade', 'thermal', [0.1, 0.9, 1.0, 1.0], 2800, 35.0, 12.0, 1.0, 0.2, 1.0, 2.0, 'additive', 'Expanding ionized plasma sphere detonation');
reg('cinder_storm', 'thermal', [0.9, 0.4, 0.1, 0.75], 1800, 12.0, 6.0, 1.0, 0.08, 4.0, 2.2, 'additive', 'Wind-driven fiery embers engulfing environment');
reg('thermobaric_cloud', 'thermal', [0.85, 0.35, 0.1, 0.9], 4500, 22.0, 10.0, -0.5, 0.15, 3.2, 2.4, 'additive', 'Fuel-air aerosol explosive fireball engulfment');
reg('phosphorus_trail', 'thermal', [1.0, 0.95, 0.7, 0.9], 1600, 16.0, 6.0, 8.0, 0.08, 2.2, 1.7, 'additive', 'White phosphorus smoking particle arcs');
reg('laser_ablation', 'thermal', [0.0, 1.0, 0.8, 1.0], 800, 20.0, 4.0, 0.0, 0.01, 0.3, 0.2, 'additive', 'Sub-millisecond high-energy laser surface vapor plume');
reg('heat_shimmer', 'thermal', [1.0, 1.0, 1.0, 0.2], 500, 2.0, 0.5, -1.8, 0.1, 3.0, 1.2, 'alpha', 'Refractive hot air density turbulence ripples');
reg('pyroclastic_flow', 'thermal', [0.5, 0.4, 0.35, 0.85], 5000, 24.0, 8.0, 2.0, 0.2, 4.5, 3.0, 'alpha', 'Superheated avalanche of ash, pumice, and volcanic rock');
reg('sparkler', 'thermal', [1.0, 0.9, 0.5, 1.0], 700, 6.0, 5.0, 9.8, 0.05, 0.6, 2.0, 'additive', 'Branching handheld pyrotechnic spark cascades');
reg('muzzle_flash', 'thermal', [1.0, 0.75, 0.3, 1.0], 1200, 45.0, 8.0, 0.0, 0.1, 0.08, 0.5, 'additive', 'Artillery gunpowder propellant deflagration flash');
reg('flare_cluster', 'thermal', [1.0, 0.4, 0.2, 0.95], 2400, 15.0, 8.0, 3.0, 0.05, 2.0, 1.5, 'additive', 'Countermeasure infrared decoy flare salvo');
reg('incendiary_bomb', 'thermal', [1.0, 0.3, 0.0, 0.9], 3000, 20.0, 10.0, 9.8, 0.1, 3.0, 2.0, 'additive', 'Submunition cluster bursting into carpet of fire');
reg('sunspot_eruption', 'thermal', [1.0, 0.85, 0.2, 0.95], 3800, 35.0, 12.0, 0.0, 0.02, 4.0, 2.8, 'additive', 'Helical magnetic reconnection magnetic loop');
reg('welding_arc', 'thermal', [0.7, 0.85, 1.0, 1.0], 900, 12.0, 6.0, 9.8, 0.04, 0.5, 1.8, 'additive', 'Electric TIG arc metal melting sparks');
reg('jet_exhaust_idle', 'thermal', [0.8, 0.85, 0.9, 0.3], 600, 8.0, 1.5, 0.0, 0.08, 1.5, 0.6, 'alpha', 'Turbofan ground idle heat haze and residual unburnt mist');
reg('magma_bubble', 'thermal', [0.95, 0.2, 0.0, 0.9], 400, 2.5, 1.0, 4.0, 0.2, 2.0, 0.5, 'alpha', 'Viscous popping gas dome ejecting molten clots');
reg('plasma_cannon', 'thermal', [0.1, 0.8, 1.0, 1.0], 2500, 70.0, 4.0, 0.0, 0.02, 0.8, 0.6, 'additive', 'Heavy magnetic rail accelerator plasma bolt');
reg('combustion_core', 'thermal', [1.0, 0.5, 0.1, 0.9], 1500, 10.0, 3.0, -1.0, 0.05, 1.8, 1.1, 'additive', 'Internal turbine combustion swirl chamber');
reg('wildfire_front', 'thermal', [0.95, 0.3, 0.05, 0.85], 4000, 14.0, 6.0, -2.0, 0.1, 3.5, 2.6, 'additive', 'Massive kilometer-wide moving wall of forest fire');
reg('fireball_cascade', 'thermal', [1.0, 0.45, 0.1, 0.9], 2800, 18.0, 7.0, 4.0, 0.08, 2.2, 1.7, 'additive', 'Rolling interconnected fireball explosions');
reg('thermo_shock', 'thermal', [0.8, 0.95, 1.0, 1.0], 2000, 40.0, 15.0, 0.0, 0.05, 0.6, 1.5, 'additive', 'Instantaneous thermal expansion crack flash');

// -------------------------------------------------------------
// 2. ELECTRIC / IONIZATION / ENERGY (40 FX)
// -------------------------------------------------------------
reg('zap', 'electric', [0.1, 0.9, 1.0, 0.95], 1000, 18.0, 10.0, 0.0, 0.01, 0.3, 3.5, 'additive', 'High-voltage jagged electrical arc discharge');
reg('tesla_arc', 'electric', [0.6, 0.2, 1.0, 0.9], 1400, 22.0, 12.0, 0.0, 0.01, 0.25, 4.0, 'additive', 'Purple resonant high-frequency Tesla coil streamers');
reg('ball_lightning', 'electric', [0.4, 0.8, 1.0, 0.95], 800, 3.0, 1.0, -0.2, 0.05, 4.0, 1.0, 'additive', 'Spherical luminescent plasma orb with corona discharge');
reg('emp_burst', 'electric', [0.0, 0.9, 0.8, 0.9], 3000, 45.0, 5.0, 0.0, 0.1, 0.8, 0.5, 'additive', 'Radial expanding electromagnetic shockwave ring');
reg('ion_stream', 'electric', [0.1, 0.6, 1.0, 0.85], 1600, 30.0, 3.0, 0.0, 0.02, 1.0, 0.6, 'additive', 'Collimated blue ionic thruster particle stream');
reg('st_elmo_fire', 'electric', [0.2, 0.8, 1.0, 0.7], 500, 1.5, 0.5, -0.5, 0.05, 3.0, 1.2, 'additive', 'Atmospheric brush corona discharge on metal masts');
reg('arc_weld', 'electric', [0.8, 0.9, 1.0, 1.0], 1200, 15.0, 8.0, 9.8, 0.04, 0.7, 2.5, 'additive', 'High-amperage short circuit electrical blinding sparks');
reg('lightning_strike', 'electric', [0.7, 0.85, 1.0, 1.0], 4000, 80.0, 20.0, 0.0, 0.01, 0.2, 5.0, 'additive', 'Ground-to-cloud stepped leader flash detonation');
reg('corona_discharge', 'electric', [0.4, 0.3, 0.95, 0.8], 900, 4.0, 1.5, 0.0, 0.02, 1.5, 1.8, 'additive', 'High-voltage transmission line luminous ionization');
reg('static_shock', 'electric', [0.5, 0.7, 1.0, 0.9], 400, 8.0, 5.0, 0.0, 0.05, 0.2, 2.0, 'additive', 'Microscopic capacitive electrostatic snap');
reg('plasma_shield', 'electric', [0.0, 0.8, 1.0, 0.75], 2500, 5.0, 1.0, 0.0, 0.0, 3.0, 0.8, 'additive', 'Deflective force field surface electrical ripple');
reg('stunlock_field', 'electric', [0.9, 0.8, 0.1, 0.9], 1800, 12.0, 6.0, 0.0, 0.05, 1.5, 3.2, 'additive', 'Neuro-muscular disabling high-frequency pulse mesh');
reg('magnetic_pinch', 'electric', [0.8, 0.1, 0.9, 1.0], 2200, 25.0, 8.0, 0.0, 0.02, 0.8, 2.8, 'additive', 'Z-pinch electromagnetic plasma compression column');
reg('positron_beam', 'electric', [1.0, 0.2, 0.5, 0.95], 1900, 65.0, 2.0, 0.0, 0.01, 0.5, 0.4, 'additive', 'Antimatter positron accelerator trace stream');
reg('spark_gap', 'electric', [0.4, 0.6, 1.0, 1.0], 1100, 16.0, 9.0, 0.0, 0.03, 0.4, 3.0, 'additive', 'Rotary spark gap transmitter discharge burst');
reg('overload_surge', 'electric', [1.0, 0.9, 0.3, 1.0], 3200, 30.0, 15.0, 4.0, 0.08, 1.0, 3.5, 'additive', 'Transformer explosion multi-phase electrical short');
reg('cathode_glow', 'electric', [0.1, 1.0, 0.4, 0.8], 600, 2.0, 0.5, 0.0, 0.01, 4.0, 0.5, 'additive', 'Vacuum tube phosphor electron beam luminescence');
reg('railgun_arc', 'electric', [0.0, 1.0, 1.0, 1.0], 2400, 75.0, 10.0, 0.0, 0.01, 0.4, 1.5, 'additive', 'Armature rail contact hypervelocity plasma sheath');
reg('synchrotron_beam', 'electric', [1.0, 0.1, 0.8, 0.95], 3000, 85.0, 1.0, 0.0, 0.0, 0.3, 0.2, 'additive', 'Relativistic particle accelerator radiation beam');
reg('dielectric_breakdown', 'electric', [0.3, 0.9, 1.0, 1.0], 1700, 24.0, 12.0, 0.0, 0.02, 0.3, 4.2, 'additive', 'Lichtenberg fractal tree discharge pattern');
reg('glow_discharge', 'electric', [1.0, 0.3, 0.1, 0.8], 800, 3.0, 1.0, 0.0, 0.05, 3.0, 0.7, 'additive', 'Neon gas excitation low-pressure luminous glow');
reg('piezo_spark', 'electric', [0.2, 0.5, 1.0, 1.0], 300, 10.0, 6.0, 9.8, 0.05, 0.25, 2.2, 'additive', 'Crystal impact mechanical-to-electrical pulse');
reg('taser_pulse', 'electric', [0.9, 0.9, 0.2, 0.95], 1300, 20.0, 8.0, 0.0, 0.04, 0.5, 2.6, 'additive', 'High-voltage pulsed probe cycle discharge');
reg('auroral_electrojet', 'electric', [0.1, 0.9, 0.6, 0.75], 2800, 6.0, 2.0, 0.0, 0.01, 5.0, 1.6, 'additive', 'Magnetospheric current sheet electron precipitation');
reg('dynode_cascade', 'electric', [0.4, 0.7, 1.0, 0.9], 1500, 14.0, 4.0, 0.0, 0.02, 0.8, 1.0, 'additive', 'Photomultiplier secondary electron amplification');
reg('laser_spark', 'electric', [1.0, 1.0, 1.0, 1.0], 1000, 35.0, 10.0, 0.0, 0.01, 0.15, 1.2, 'additive', 'Air breakdown optical breakdown spark point');
reg('hyper_conduit', 'electric', [0.0, 0.8, 1.0, 0.9], 2200, 40.0, 5.0, 0.0, 0.01, 0.7, 0.8, 'additive', 'Superconducting energy pipeline flow conduit');
reg('vortex_arc', 'electric', [0.7, 0.2, 1.0, 0.95], 2600, 18.0, 6.0, -1.0, 0.03, 1.6, 3.0, 'additive', 'Tornado of swirling rotating electric lightning');
reg('tachyon_zap', 'electric', [0.1, 1.0, 0.9, 1.0], 1800, 90.0, 5.0, 0.0, 0.0, 0.2, 0.5, 'additive', 'Faster-than-light inverted temporal energy discharge');
reg('cascade_short', 'electric', [1.0, 0.8, 0.2, 0.95], 2100, 20.0, 10.0, 4.0, 0.06, 0.9, 3.4, 'additive', 'Multi-circuit breaker blowout cascade');
reg('quantum_tunnel_arc', 'electric', [0.5, 0.1, 1.0, 0.9], 1400, 30.0, 15.0, 0.0, 0.01, 0.4, 4.0, 'additive', 'Barrier penetration probabilistic arc jump');
reg('ion_cyclotron', 'electric', [0.2, 0.7, 1.0, 0.85], 2000, 16.0, 3.0, 0.0, 0.01, 2.0, 1.4, 'additive', 'Resonance gyrofrequency orbital particle ring');
reg('solar_wind_flux', 'electric', [1.0, 0.95, 0.6, 0.7], 3500, 45.0, 10.0, 0.0, 0.01, 3.0, 1.5, 'additive', 'Heliospheric proton and electron interplanetary stream');
reg('plasma_filament', 'electric', [0.3, 0.9, 1.0, 0.9], 1600, 12.0, 4.0, 0.0, 0.02, 1.8, 2.5, 'additive', 'Self-constricting Birkeland current rope');
reg('charge_well', 'electric', [0.0, 0.9, 0.8, 0.8], 1900, -15.0, 3.0, 0.0, 0.05, 1.5, 1.2, 'additive', 'Coulomb negative potential attractive vortex');
reg('shock_streamer', 'electric', [0.8, 0.3, 1.0, 1.0], 1500, 28.0, 12.0, 0.0, 0.02, 0.35, 3.8, 'additive', 'Pre-breakdown ionized leader channel branching');
reg('spark_spray', 'electric', [1.0, 0.9, 0.4, 1.0], 1200, 15.0, 8.0, 9.8, 0.03, 0.8, 2.0, 'additive', 'Rotary grinder electric contact ember shower');
reg('arc_cannon', 'electric', [0.1, 0.8, 1.0, 1.0], 3000, 60.0, 8.0, 0.0, 0.02, 0.7, 1.5, 'additive', 'High-density coherent energy bolt');
reg('stator_spark', 'electric', [0.6, 0.8, 1.0, 0.9], 800, 10.0, 4.0, 2.0, 0.04, 0.6, 1.8, 'additive', 'Electric motor brush commutator sparks');
reg('electrolaser_channel', 'electric', [0.2, 1.0, 0.8, 1.0], 2500, 85.0, 2.0, 0.0, 0.0, 0.3, 0.4, 'additive', 'Ultraviolet laser atmospheric ionized conduit');

// -------------------------------------------------------------
// 3. FLUID / LIQUID / CRYO (40 FX)
// -------------------------------------------------------------
reg('splash', 'fluid', [0.4, 0.7, 0.95, 0.8], 1200, 10.0, 4.0, 9.8, 0.1, 1.5, 0.5, 'alpha', 'Crown-shaped water impact splash with parabolic droplets');
reg('splatter', 'fluid', [0.8, 0.1, 0.1, 0.85], 900, 14.0, 6.0, 9.8, 0.12, 1.2, 0.8, 'alpha', 'High-velocity fluid breakup with surface sticking');
reg('slime', 'fluid', [0.2, 0.9, 0.2, 0.85], 500, 4.0, 1.5, 6.0, 0.4, 3.5, 0.3, 'alpha', 'Viscous non-Newtonian goo dripping with stringy cohesion');
reg('blizzard', 'fluid', [0.95, 0.98, 1.0, 0.75], 3500, 20.0, 8.0, 1.5, 0.2, 2.5, 2.5, 'alpha', 'Zero-visibility arctic snowstorm with howling crosswinds');
reg('liquid_nitrogen', 'fluid', [0.8, 0.9, 1.0, 0.6], 2000, 5.0, 2.0, 2.0, 0.3, 3.0, 1.2, 'alpha', 'Sub-zero cryogenic fog pooling and creeping across floor');
reg('acid_spray', 'fluid', [0.5, 1.0, 0.1, 0.9], 1600, 16.0, 4.0, 9.8, 0.1, 1.4, 0.8, 'alpha', 'Corrosive pressurized acid spray with bubbling hiss');
reg('oil_slick', 'fluid', [0.1, 0.1, 0.15, 0.9], 400, 2.0, 0.5, 9.8, 0.5, 6.0, 0.1, 'alpha', 'Hydrocarbon crude oil film with iridescent sheen');
reg('waterfall_mist', 'fluid', [0.85, 0.95, 1.0, 0.45], 3000, 8.0, 3.0, 1.0, 0.15, 4.0, 1.4, 'alpha', 'Plunging cataract pulverized water vapor cloud');
reg('blood_mist', 'fluid', [0.65, 0.05, 0.05, 0.8], 1400, 12.0, 5.0, 6.0, 0.18, 1.8, 0.9, 'alpha', 'High-pressure arterial mist aerosol');
reg('fountain_jet', 'fluid', [0.6, 0.85, 1.0, 0.7], 1500, 18.0, 2.0, 9.8, 0.05, 2.2, 0.3, 'alpha', 'Laminar vertical architectural water jet fountain');
reg('frostbite_crystal', 'fluid', [0.75, 0.9, 1.0, 0.85], 800, 3.0, 1.0, 0.0, 0.05, 3.5, 0.4, 'additive', 'Rapid freezing dendrite ice crystal nucleation');
reg('heavy_rain', 'fluid', [0.6, 0.75, 0.9, 0.65], 4000, 30.0, 4.0, 15.0, 0.05, 1.2, 0.4, 'alpha', 'Torrential downpour with high terminal velocity drops');
reg('dew_droplets', 'fluid', [0.9, 0.95, 1.0, 0.6], 300, 0.5, 0.2, 1.0, 0.3, 5.0, 0.1, 'alpha', 'Microscopic morning dew condensation spheres');
reg('geyser_spout', 'fluid', [0.9, 0.95, 1.0, 0.75], 2500, 35.0, 6.0, 9.8, 0.08, 2.5, 1.1, 'alpha', 'Geothermal superheated water and steam column');
reg('mud_geyser', 'fluid', [0.4, 0.3, 0.2, 0.9], 1000, 10.0, 4.0, 9.8, 0.35, 2.0, 0.6, 'alpha', 'Thick bubbling silt mud eruption');
reg('bubble_stream', 'fluid', [0.7, 0.9, 1.0, 0.5], 1200, 4.0, 1.0, -4.0, 0.2, 3.0, 0.8, 'alpha', 'Underwater buoyant air cavitation bubbles');
reg('ocean_wake', 'fluid', [0.85, 0.95, 1.0, 0.6], 2200, 8.0, 4.0, 4.0, 0.15, 2.5, 1.2, 'alpha', 'Naval hull displacement turbulent white water wake');
reg('toxic_ooze', 'fluid', [0.3, 0.95, 0.1, 0.9], 600, 2.5, 0.8, 8.0, 0.45, 4.5, 0.2, 'alpha', 'Luminescent biohazard chemical sludge leak');
reg('steam_vent', 'fluid', [0.9, 0.9, 0.95, 0.4], 1800, 15.0, 3.0, -1.0, 0.12, 2.8, 1.0, 'alpha', 'Pressurized boiler steam valve release plume');
reg('drizzle', 'fluid', [0.7, 0.8, 0.9, 0.4], 1500, 8.0, 2.0, 5.0, 0.1, 2.0, 0.3, 'alpha', 'Gentle low-velocity ambient rain mist');
reg('hailstorm', 'fluid', [0.9, 0.95, 1.0, 0.9], 2000, 35.0, 5.0, 20.0, 0.02, 1.0, 0.2, 'alpha', 'Hard ice pellets ricocheting off surfaces');
reg('tar_pit', 'fluid', [0.05, 0.05, 0.05, 0.95], 300, 1.2, 0.4, 9.8, 0.6, 7.0, 0.1, 'alpha', 'Heavy pitch asphalt bubbling with noxious fumes');
reg('honey_drip', 'fluid', [0.95, 0.75, 0.1, 0.9], 400, 2.0, 0.5, 9.8, 0.5, 4.0, 0.1, 'alpha', 'Golden high-viscosity viscous amber fluid strings');
reg('foam_dispersion', 'fluid', [0.95, 0.98, 1.0, 0.8], 1700, 6.0, 3.0, 2.0, 0.3, 3.5, 0.7, 'alpha', 'Fire suppression aqueous film-forming foam blanket');
reg('frost_breath', 'fluid', [0.85, 0.92, 1.0, 0.5], 900, 3.0, 1.0, -0.2, 0.1, 2.2, 0.6, 'alpha', 'Human cold-weather exhalation condensation cloud');
reg('cryo_beam', 'fluid', [0.3, 0.8, 1.0, 0.9], 2600, 45.0, 3.0, 0.0, 0.05, 0.8, 0.7, 'additive', 'Absolute zero freezing particle projection beam');
reg('quicksand', 'fluid', [0.65, 0.55, 0.35, 0.9], 800, 1.5, 0.5, 9.8, 0.4, 5.0, 0.2, 'alpha', 'Thixotropic fluid sand liquefaction sink');
reg('slosh_wave', 'fluid', [0.5, 0.8, 0.95, 0.7], 1800, 8.0, 3.0, 9.8, 0.15, 1.8, 0.9, 'alpha', 'Container sloshing dynamic fluid boundary waves');
reg('paint_blast', 'fluid', [1.0, 0.1, 0.6, 0.9], 1500, 22.0, 8.0, 9.8, 0.12, 1.0, 1.2, 'alpha', 'Pressurized aerosol paint atomization burst');
reg('mercury_droplets', 'fluid', [0.85, 0.85, 0.9, 0.95], 600, 5.0, 2.0, 18.0, 0.02, 2.0, 0.3, 'alpha', 'Dense high-surface-tension liquid metal beads');
reg('water_pulse', 'fluid', [0.3, 0.75, 1.0, 0.8], 2200, 30.0, 4.0, 5.0, 0.05, 1.2, 0.6, 'alpha', 'High-pressure hydraulic water cannon burst');
reg('sleet', 'fluid', [0.8, 0.88, 0.95, 0.7], 2400, 22.0, 4.0, 12.0, 0.08, 1.5, 0.8, 'alpha', 'Freezing rain transition ice slush mixture');
reg('chemical_spill', 'fluid', [0.8, 0.95, 0.2, 0.85], 900, 4.0, 1.5, 9.8, 0.2, 4.0, 0.4, 'alpha', 'Spreading iridescent volatile reagent slick');
reg('ink_cloud', 'fluid', [0.1, 0.05, 0.15, 0.85], 1600, 3.5, 1.2, 0.5, 0.25, 4.5, 1.1, 'alpha', 'Cephalopod defensive underwater pigment dispersion');
reg('whirlpool_funnel', 'fluid', [0.3, 0.6, 0.85, 0.75], 3200, 14.0, 4.0, 4.0, 0.1, 3.0, 2.0, 'alpha', 'Centripetal aquatic vortex suction spiral');
reg('beer_foam', 'fluid', [1.0, 0.95, 0.8, 0.85], 700, 2.0, 0.6, 1.0, 0.35, 3.5, 0.3, 'alpha', 'Microbubble head effervescence collapse');
reg('coolant_leak', 'fluid', [0.0, 1.0, 0.7, 0.8], 1100, 7.0, 2.0, 9.8, 0.15, 2.2, 0.5, 'alpha', 'Radiator ethylene glycol green fluid spray');
reg('permafrost_thaw', 'fluid', [0.7, 0.75, 0.8, 0.6], 500, 1.0, 0.3, 9.8, 0.3, 5.0, 0.2, 'alpha', 'Melting tundra ice slurry runoff');
reg('hydraulic_jet', 'fluid', [0.9, 0.2, 0.1, 0.9], 1900, 50.0, 3.0, 9.8, 0.08, 0.6, 0.4, 'alpha', 'Pin-hole ultra-high-pressure hydraulic oil jet');
reg('cryo_fog_wall', 'fluid', [0.85, 0.95, 1.0, 0.55], 2800, 6.0, 2.0, 1.5, 0.2, 3.8, 1.4, 'alpha', 'Dense cryogenic cold gas boundary barrier');

// -------------------------------------------------------------
// 4. KINETIC / EXPLOSIVE / SHOCKWAVE (40 FX)
// -------------------------------------------------------------
reg('explode', 'kinetic', [1.0, 0.7, 0.1, 0.95], 2500, 28.0, 10.0, 4.0, 0.25, 1.4, 1.8, 'additive', 'High-explosive detonation fireball and supersonic blast wave');
reg('implode', 'kinetic', [0.3, 0.1, 0.8, 0.9], 2000, -20.0, 5.0, 0.0, 0.05, 1.2, 1.0, 'additive', 'Centripetal vacuum collapse suction field');
reg('splinter', 'kinetic', [0.6, 0.45, 0.3, 0.9], 600, 18.0, 8.0, 9.8, 0.1, 2.0, 0.5, 'alpha', 'Fractured wooden/composite shard shrapnel debris');
reg('sonic_boom', 'kinetic', [1.0, 1.0, 1.0, 0.8], 1800, 50.0, 5.0, 0.0, 0.3, 0.5, 0.2, 'additive', 'Prandtl-Glauert supersonic condensation cone shockwave');
reg('railgun_slug', 'kinetic', [0.0, 0.8, 1.0, 1.0], 1500, 90.0, 2.0, 0.0, 0.01, 0.3, 0.1, 'additive', 'Mach 7 hypervelocity projectile with ionized vacuum wake');
reg('shrapnel_burst', 'kinetic', [0.8, 0.8, 0.85, 0.95], 2200, 40.0, 15.0, 9.8, 0.04, 1.2, 1.2, 'additive', 'Hardened steel ball bearing fragmentation radial spray');
reg('concussion_wave', 'kinetic', [1.0, 1.0, 1.0, 0.5], 2600, 35.0, 2.0, 0.0, 0.15, 0.6, 0.3, 'alpha', 'High-pressure air refractive blast displacement wave');
reg('kinetic_impact', 'kinetic', [0.7, 0.65, 0.6, 0.9], 1800, 22.0, 10.0, 12.0, 0.15, 1.5, 1.6, 'alpha', 'Heavy armor projectile crater pulverization debris');
reg('orbital_strike', 'kinetic', [0.4, 0.7, 1.0, 1.0], 5000, 100.0, 10.0, 2.0, 0.01, 2.0, 1.0, 'additive', 'Tungsten kinetic rod of god hypervelocity ground impact');
reg('depth_charge', 'kinetic', [0.8, 0.9, 1.0, 0.8], 3000, 25.0, 8.0, 2.0, 0.3, 2.0, 1.5, 'alpha', 'Sub-surface hydrostatic bubble explosion and plume');
reg('grenade_burst', 'kinetic', [0.9, 0.5, 0.1, 0.95], 1600, 24.0, 8.0, 9.8, 0.18, 1.2, 1.4, 'additive', 'M67 fragmentation grenade prompt blast and dust');
reg('flak_burst', 'kinetic', [0.4, 0.4, 0.4, 0.9], 1400, 15.0, 6.0, 2.0, 0.1, 2.2, 1.8, 'alpha', 'Anti-aircraft altitude timed black explosive smoke cloud');
reg('bullet_ricochet', 'kinetic', [1.0, 0.9, 0.4, 1.0], 500, 35.0, 15.0, 9.8, 0.05, 0.4, 2.0, 'additive', 'Grazing angle lead/copper bullet spark deflection');
reg('concrete_dust', 'kinetic', [0.75, 0.7, 0.65, 0.7], 2000, 10.0, 5.0, 4.0, 0.25, 3.5, 1.4, 'alpha', 'Structural masonry collapse pulverized dust cloud');
reg('glass_shatter', 'kinetic', [0.8, 0.95, 1.0, 0.8], 900, 16.0, 8.0, 9.8, 0.05, 1.8, 0.6, 'alpha', 'Tempered safety glass cubic crystalline fragment spray');
reg('rockfall', 'kinetic', [0.55, 0.5, 0.45, 0.95], 1100, 12.0, 6.0, 14.0, 0.08, 2.8, 0.8, 'alpha', 'Cliffside boulder tumble and gravitational impact sparks');
reg('avalanche', 'kinetic', [0.9, 0.95, 1.0, 0.8], 4500, 20.0, 6.0, 8.0, 0.18, 4.0, 2.2, 'alpha', 'Massive mountain snow slab turbulent powder cloud');
reg('c4_breach', 'kinetic', [1.0, 0.8, 0.3, 0.95], 2800, 45.0, 12.0, 2.0, 0.15, 0.8, 1.6, 'additive', 'Directional linear shaped charge wall breach blast');
reg('mortar_impact', 'kinetic', [0.6, 0.5, 0.4, 0.9], 2200, 26.0, 10.0, 9.8, 0.2, 2.2, 1.9, 'alpha', 'High-angle 120mm mortar ground crater ejection');
reg('claymore_fan', 'kinetic', [0.8, 0.8, 0.7, 0.9], 3200, 50.0, 6.0, 4.0, 0.05, 0.6, 0.9, 'additive', 'Directional 60-degree steel pellet fan fragmentation');
reg('minefield_blast', 'kinetic', [0.85, 0.6, 0.2, 0.95], 2400, 30.0, 10.0, 9.8, 0.16, 1.5, 1.7, 'additive', 'Anti-tank pressure plate subsurface detonation');
reg('dust_devil', 'kinetic', [0.75, 0.65, 0.5, 0.65], 1800, 8.0, 3.0, -1.0, 0.1, 5.0, 2.8, 'alpha', 'Ground thermal convective rotating dust vortex');
reg('meteor_crater', 'kinetic', [0.7, 0.4, 0.2, 0.95], 4000, 40.0, 15.0, 9.8, 0.12, 3.0, 2.2, 'additive', 'Hypersonic bolide impact ground excavation plume');
reg('vacuum_collapse', 'kinetic', [0.2, 0.4, 0.9, 0.9], 2100, -30.0, 6.0, 0.0, 0.02, 0.8, 1.4, 'additive', 'High-velocity atmospheric air rush into evacuated cavity');
reg('torpedo_hit', 'kinetic', [0.6, 0.8, 0.95, 0.9], 3500, 32.0, 12.0, 6.0, 0.2, 2.4, 2.0, 'alpha', 'Underwater hull keel rupture steam and water geyser');
reg('flak_curtain', 'kinetic', [0.5, 0.5, 0.55, 0.8], 3000, 18.0, 8.0, 3.0, 0.12, 2.6, 2.1, 'alpha', 'Dense interlocking anti-aircraft shell air bursts');
reg('supersonic_crack', 'kinetic', [1.0, 1.0, 1.0, 0.9], 800, 60.0, 4.0, 0.0, 0.05, 0.2, 0.3, 'additive', 'Bullet passing Mach 1 shockwave acoustic cone');
reg('armor_spall', 'kinetic', [1.0, 0.7, 0.3, 1.0], 1300, 32.0, 14.0, 9.8, 0.04, 0.7, 1.8, 'additive', 'Inside hull back-face armor scab splinter shower');
reg('kinetic_barrier', 'kinetic', [0.2, 0.6, 1.0, 0.8], 1700, 15.0, 5.0, 0.0, 0.05, 1.0, 1.0, 'additive', 'Momentum absorption barrier energy dispersion wave');
reg('seismic_rupture', 'kinetic', [0.6, 0.5, 0.4, 0.85], 2600, 14.0, 6.0, 12.0, 0.18, 3.5, 2.0, 'alpha', 'Tectonic fault displacement earth fracture dust');
reg('demolition_drop', 'kinetic', [0.7, 0.65, 0.6, 0.75], 4200, 16.0, 8.0, 6.0, 0.22, 4.0, 2.5, 'alpha', 'Building controlled explosive implosion dust cloud');
reg('hull_puncture', 'kinetic', [0.9, 0.95, 1.0, 0.8], 1500, 40.0, 8.0, 0.0, 0.1, 1.0, 1.2, 'alpha', 'Spacecraft vacuum decompression atmospheric blowout');
reg('debris_cloud', 'kinetic', [0.7, 0.65, 0.6, 0.6], 1900, 6.0, 3.0, 1.0, 0.15, 6.0, 1.5, 'alpha', 'Orbiting satellite fragmentation cloud dispersion');
reg('blast_funnel', 'kinetic', [0.8, 0.6, 0.3, 0.9], 2700, 30.0, 8.0, 4.0, 0.12, 1.6, 1.8, 'additive', 'Conical shaped charge penetration jet channel');
reg('kinetic_whip', 'kinetic', [0.0, 0.9, 1.0, 0.95], 1200, 45.0, 10.0, 0.0, 0.03, 0.5, 1.9, 'additive', 'High-velocity segmented whip sonic crack');
reg('anti_tank_jet', 'kinetic', [1.0, 0.85, 0.4, 1.0], 2100, 85.0, 6.0, 0.0, 0.01, 0.3, 0.8, 'additive', 'HEAT warhead copper liner hypervelocity slug');
reg('shrapnel_cone', 'kinetic', [0.75, 0.75, 0.8, 0.9], 2300, 42.0, 12.0, 6.0, 0.06, 1.1, 1.3, 'additive', 'Forward-ejecting projectile tungsten ball cone');
reg('hydrodynamic_cavity', 'kinetic', [0.4, 0.8, 1.0, 0.75], 1800, 20.0, 6.0, 2.0, 0.25, 1.4, 1.1, 'alpha', 'High-speed supercavitating underwater bubble tube');
reg('crater_ejecta', 'kinetic', [0.6, 0.55, 0.5, 0.9], 2400, 22.0, 9.0, 12.0, 0.12, 2.2, 1.5, 'alpha', 'Parabolic ballistic soil and rock ejecta curtain');
reg('kinetic_deflection', 'kinetic', [1.0, 0.9, 0.5, 1.0], 1100, 26.0, 10.0, 9.8, 0.05, 0.6, 2.2, 'additive', 'Active protection system projectile intercept burst');

// -------------------------------------------------------------
// 5. COSMIC / QUANTUM / DISTORTION (40 FX)
// -------------------------------------------------------------
reg('nebula', 'cosmic', [0.4, 0.3, 0.95, 0.8], 4000, 1.5, 1.0, 0.0, 0.01, 8.0, 1.4, 'additive', 'Deep interstellar cosmic gas cloud with chromatic gradients');
reg('wormhole_rift', 'cosmic', [0.0, 0.9, 0.8, 0.95], 3000, 12.0, 4.0, 0.0, 0.02, 3.0, 3.0, 'additive', 'Einstein-Rosen spacetime distortion vortex with event horizon');
reg('dark_matter_halo', 'cosmic', [0.15, 0.05, 0.3, 0.7], 2000, 2.0, 0.5, 0.0, 0.0, 6.0, 0.8, 'alpha', 'Gravitational lensing shadow halo around massive core');
reg('graviton_well', 'cosmic', [0.7, 0.1, 0.9, 0.85], 2500, -18.0, 4.0, 0.0, 0.05, 2.5, 2.0, 'additive', 'Singularity gravitational inward matter attraction');
reg('tachyon_beam', 'cosmic', [0.2, 1.0, 0.5, 0.95], 2200, 95.0, 1.0, 0.0, 0.0, 0.4, 0.3, 'additive', 'Cherenkov radiation faster-than-light particle beam');
reg('event_horizon', 'cosmic', [0.0, 0.0, 0.0, 1.0], 1500, -8.0, 2.0, 0.0, 0.0, 5.0, 0.5, 'alpha', 'Black hole photon sphere infinite redshift boundary');
reg('quantum_foam', 'cosmic', [0.6, 0.8, 1.0, 0.7], 1800, 3.0, 2.0, 0.0, 0.0, 2.0, 4.0, 'additive', 'Planck-scale virtual particle pair creation and annihilation');
reg('pulsar_beam', 'cosmic', [0.9, 0.4, 1.0, 0.95], 3200, 70.0, 3.0, 0.0, 0.0, 1.2, 0.6, 'additive', 'Rotating neutron star relativistic magnetic dipole jet');
reg('gamma_ray_burst', 'cosmic', [0.0, 0.9, 1.0, 1.0], 4500, 95.0, 2.0, 0.0, 0.0, 0.8, 0.4, 'additive', 'Supernova hyper-collimated energetic beam burst');
reg('warp_bubble', 'cosmic', [0.3, 0.7, 1.0, 0.8], 2800, 20.0, 5.0, 0.0, 0.0, 2.2, 1.8, 'additive', 'Alcubierre metric space contraction/expansion sheath');
reg('cosmic_ray_shower', 'cosmic', [0.8, 0.9, 1.0, 0.9], 3000, 60.0, 15.0, 2.0, 0.01, 1.0, 1.5, 'additive', 'Upper atmospheric secondary muon particle cascade');
reg('spacetime_ripple', 'cosmic', [0.4, 0.8, 0.95, 0.6], 1900, 15.0, 1.0, 0.0, 0.0, 3.0, 0.5, 'additive', 'Binary black hole coalescence gravitational quadrupole wave');
reg('singularity_accretion', 'cosmic', [1.0, 0.6, 0.1, 0.95], 3600, 25.0, 8.0, 0.0, 0.02, 3.0, 2.4, 'additive', 'Superheated relativistic disk plasma swirling into black hole');
reg('dark_energy_flow', 'cosmic', [0.2, 0.05, 0.4, 0.6], 2200, 4.0, 1.0, 0.0, 0.0, 7.0, 0.9, 'additive', 'Cosmological constant accelerated spacetime expansion field');
reg('void_rift', 'cosmic', [0.8, 0.0, 0.6, 0.9], 2000, 10.0, 4.0, 0.0, 0.02, 3.0, 2.8, 'additive', 'Dimensional planar fracture emitting exotic vacuum energy');
reg('hyperdrive_streak', 'cosmic', [0.95, 0.98, 1.0, 1.0], 3500, 90.0, 5.0, 0.0, 0.0, 0.5, 0.2, 'additive', 'Starlight parallax stretching into hyperspace streak lines');
reg('astral_mist', 'cosmic', [0.5, 0.2, 0.8, 0.7], 1600, 2.0, 0.8, 0.0, 0.02, 5.0, 1.2, 'additive', 'Ethereal glowing spiritual plane atmospheric fog');
reg('zero_point_flux', 'cosmic', [0.2, 0.9, 0.8, 0.85], 2100, 6.0, 3.0, 0.0, 0.0, 2.5, 3.5, 'additive', 'Casimir vacuum fluctuation spontaneous energy sparks');
reg('antimatter_annihilation', 'cosmic', [1.0, 0.1, 0.4, 1.0], 3200, 50.0, 15.0, 0.0, 0.01, 0.8, 2.0, 'additive', 'Proton-antiproton direct mass-to-energy conversion flash');
reg('chromatic_glitch', 'cosmic', [0.0, 1.0, 0.8, 0.9], 1400, 10.0, 8.0, 0.0, 0.0, 0.6, 4.5, 'additive', 'RGB optical prism holographic aberration displacement');
reg('time_dilation_field', 'cosmic', [0.7, 0.9, 1.0, 0.6], 1200, 0.5, 0.1, 0.0, 0.0, 6.0, 0.2, 'additive', 'Local chrono-metric slowing field visual shimmer');
reg('quantum_entanglement', 'cosmic', [0.9, 0.2, 0.8, 0.9], 1500, 14.0, 2.0, 0.0, 0.0, 2.0, 1.0, 'additive', 'Spooky action non-local twin particle spin links');
reg('quasar_core', 'cosmic', [1.0, 0.95, 0.8, 1.0], 4200, 65.0, 10.0, 0.0, 0.0, 2.0, 1.6, 'additive', 'Active galactic nucleus trillion-solar-luminosity jet');
reg('solar_corona', 'cosmic', [1.0, 0.9, 0.6, 0.75], 2600, 8.0, 3.0, 0.0, 0.01, 4.5, 1.8, 'additive', 'Millions-of-degrees solar atmospheric plasma envelope');
reg('supernova_remnant', 'cosmic', [0.3, 0.8, 0.95, 0.8], 3400, 16.0, 5.0, 0.0, 0.01, 5.5, 2.2, 'additive', 'Expanding filamentary nebula shell enriched with heavy elements');
reg('string_vibration', 'cosmic', [0.8, 0.4, 1.0, 0.85], 1100, 5.0, 2.0, 0.0, 0.0, 3.0, 3.0, 'additive', '11-dimensional Calabi-Yau manifold harmonic resonance');
reg('black_hole_shadow', 'cosmic', [0.1, 0.05, 0.2, 0.9], 1800, -12.0, 2.0, 0.0, 0.0, 4.0, 0.7, 'alpha', 'Gravitational photon capture dark silhouette circle');
reg('star_nursery', 'cosmic', [0.9, 0.3, 0.7, 0.7], 2700, 2.5, 1.0, 0.0, 0.01, 7.0, 1.3, 'additive', 'Molecular hydrogen cloud condensing into protostars');
reg('cosmic_dust_lane', 'cosmic', [0.25, 0.15, 0.1, 0.8], 1500, 1.0, 0.3, 0.0, 0.0, 8.0, 0.6, 'alpha', 'Galactic spiral arm interstellar carbonaceous dust band');
reg('oort_cloud_drift', 'cosmic', [0.8, 0.85, 0.95, 0.5], 800, 0.4, 0.1, 0.0, 0.0, 9.0, 0.2, 'additive', 'Outer solar system icy planetesimal tranquil drift');
reg('magnetar_burst', 'cosmic', [0.5, 0.9, 1.0, 1.0], 3800, 75.0, 15.0, 0.0, 0.0, 0.9, 2.5, 'additive', 'Crustal starquake quadrillion-gauss magnetic flare');
reg('holographic_matrix', 'cosmic', [0.0, 1.0, 0.6, 0.85], 1900, 8.0, 2.0, 0.0, 0.0, 2.0, 0.5, 'additive', 'Hexagonal digital wireframe volumetric voxel grid');
reg('gravitational_lens', 'cosmic', [0.7, 0.85, 1.0, 0.65], 2100, 6.0, 1.0, 0.0, 0.0, 4.0, 0.4, 'additive', 'Einstein ring light bending curved arc distortion');
reg('vacuum_polarization', 'cosmic', [0.4, 0.1, 0.9, 0.8], 1600, 8.0, 3.0, 0.0, 0.0, 2.2, 2.2, 'additive', 'Strong field Schwinger electron-positron virtual pairs');
reg('subspace_beacon', 'cosmic', [0.1, 0.95, 0.8, 0.9], 1500, 20.0, 2.0, 0.0, 0.0, 2.0, 0.4, 'additive', 'Interstellar navigational pulse ring transmitter');
reg('chronal_rift', 'cosmic', [1.0, 0.8, 0.2, 0.85], 2300, 12.0, 5.0, 0.0, 0.01, 2.5, 3.2, 'additive', 'Temporal entropy breakdown spiral vortex');
reg('dark_matter_filament', 'cosmic', [0.1, 0.15, 0.3, 0.75], 1700, 1.8, 0.4, 0.0, 0.0, 7.5, 0.9, 'alpha', 'Cosmic web large-scale gravitational skeleton structure');
reg('neutrino_burst', 'cosmic', [0.85, 0.95, 1.0, 0.9], 3100, 90.0, 1.0, 0.0, 0.0, 0.5, 0.1, 'additive', 'Core collapse unhindered ghost particle sphere blast');
reg('antigravity_field', 'cosmic', [0.3, 1.0, 0.9, 0.8], 1400, -5.0, 1.0, -8.0, 0.05, 3.0, 0.8, 'additive', 'Negative mass upward levitation spatial field');
reg('cosmic_string_loop', 'cosmic', [1.0, 0.2, 0.9, 0.95], 2400, 30.0, 8.0, 0.0, 0.0, 1.5, 2.8, 'additive', 'Relativistic topological defect oscillating cusp radiation');

// -------------------------------------------------------------
// 6. ATMOSPHERIC / ENVIRONMENTAL / BIO (40 FX)
// -------------------------------------------------------------
reg('foggy', 'atmospheric', [0.85, 0.9, 0.95, 0.25], 1000, 0.8, 0.4, 0.0, 0.2, 6.0, 0.5, 'alpha', 'Volumetric ground fog with exponential altitude decay');
reg('sandstorm', 'atmospheric', [0.8, 0.65, 0.4, 0.7], 3000, 25.0, 8.0, 0.5, 0.1, 2.5, 2.0, 'alpha', 'Desert haboob sand wall with abrasive particulate turbulence');
reg('aurora_borealis', 'atmospheric', [0.1, 0.95, 0.5, 0.6], 2200, 1.2, 0.6, -0.1, 0.01, 7.0, 2.2, 'additive', 'Ionospheric ribbon curtains glowing with solar wind excitation');
reg('bioluminescence', 'atmospheric', [0.0, 0.85, 0.7, 0.8], 800, 1.0, 0.5, -0.2, 0.1, 5.0, 0.7, 'additive', 'Deep-sea luminous plankton emitting pulsed cyan glow');
reg('spore_cloud', 'atmospheric', [0.6, 0.85, 0.3, 0.75], 1200, 2.0, 1.0, -0.2, 0.15, 5.0, 1.2, 'alpha', 'Fungal alien spore eruption dispersing in wind');
reg('fireflies', 'atmospheric', [0.8, 1.0, 0.2, 0.9], 300, 1.2, 0.8, -0.1, 0.05, 4.0, 1.8, 'additive', 'Nocturnal bioluminescent insects blinking intermittently');
reg('pollen_drift', 'atmospheric', [0.95, 0.9, 0.4, 0.5], 700, 1.5, 0.5, 0.2, 0.1, 6.0, 0.9, 'alpha', 'Spring golden floral pollen floating in gentle breeze');
reg('smog_haze', 'atmospheric', [0.55, 0.5, 0.45, 0.6], 1400, 1.0, 0.3, 0.0, 0.2, 6.0, 0.6, 'alpha', 'Industrial particulate pollution inversion layer');
reg('toxic_fallout', 'atmospheric', [0.4, 0.85, 0.2, 0.65], 1600, 3.0, 1.0, 2.0, 0.18, 5.0, 1.4, 'alpha', 'Post-nuclear irradiated particulate fallout settling');
reg('locust_swarm', 'atmospheric', [0.45, 0.35, 0.2, 0.9], 2500, 18.0, 6.0, 0.5, 0.05, 3.5, 2.4, 'alpha', 'Dense chaotic agricultural locust horde in flight');
reg('radiation_shimmer', 'atmospheric', [0.2, 1.0, 0.6, 0.5], 1100, 2.5, 1.0, -1.0, 0.08, 3.0, 1.5, 'additive', 'Gamma ionization atmospheric Cherenkov glimmer');
reg('swamp_miasma', 'atmospheric', [0.4, 0.6, 0.3, 0.55], 900, 1.2, 0.4, -0.3, 0.15, 5.5, 0.8, 'alpha', 'Decomposing organic peat bog methane mist');
reg('autumn_leaves', 'atmospheric', [0.9, 0.4, 0.1, 0.85], 500, 5.0, 2.5, 3.0, 0.35, 4.5, 1.6, 'alpha', 'Tumbling deciduous golden and red leaf flakes');
reg('ash_cloud', 'atmospheric', [0.6, 0.6, 0.65, 0.7], 2800, 4.0, 2.0, 1.5, 0.2, 5.0, 1.7, 'alpha', 'Volcanic silty gray ash blanket fallout');
reg('desert_mirage', 'atmospheric', [0.95, 0.9, 0.75, 0.3], 600, 1.5, 0.5, -0.8, 0.1, 4.0, 1.1, 'alpha', 'Ground thermal refractive inversion optical lake');
reg('thunderhead_updraft', 'atmospheric', [0.7, 0.75, 0.85, 0.6], 3500, 16.0, 4.0, -6.0, 0.1, 4.0, 2.0, 'alpha', 'Cumulonimbus convective anvil storm cloud core');
reg('dandelion_seeds', 'atmospheric', [1.0, 1.0, 0.95, 0.7], 400, 2.0, 1.0, -0.1, 0.25, 6.0, 1.3, 'alpha', 'Airborne pappus parachutes drifting in thermals');
reg('plankton_bloom', 'atmospheric', [0.1, 0.7, 0.85, 0.7], 1500, 0.8, 0.3, -0.1, 0.1, 6.5, 0.5, 'alpha', 'Surface ocean chlorophyll microalgae bloom');
reg('haboob_crest', 'atmospheric', [0.75, 0.55, 0.35, 0.8], 3800, 28.0, 8.0, 1.0, 0.15, 3.0, 2.6, 'alpha', 'Rolling turbulent dust storm atmospheric front');
reg('sea_fog', 'atmospheric', [0.8, 0.88, 0.92, 0.4], 1300, 1.5, 0.5, 0.0, 0.18, 6.0, 0.7, 'alpha', 'Advection marine fog rolling across coastline');
reg('dust_motes', 'atmospheric', [1.0, 0.95, 0.8, 0.5], 250, 0.4, 0.2, 0.0, 0.08, 6.0, 0.4, 'additive', 'Interior sunbeam dancing airborne dust motes');
reg('jellyfish_drift', 'atmospheric', [0.8, 0.3, 0.9, 0.75], 350, 1.0, 0.3, -0.4, 0.2, 6.0, 0.6, 'additive', 'Pelagic siphonophore luminous deep-sea swarm');
reg('snow_flurries', 'atmospheric', [0.95, 0.98, 1.0, 0.8], 1800, 4.0, 2.0, 3.0, 0.2, 3.5, 1.4, 'alpha', 'Light crisp winter snow flakes dancing in wind');
reg('volcanic_smog', 'atmospheric', [0.7, 0.75, 0.6, 0.6], 1900, 3.0, 1.0, -0.5, 0.15, 5.0, 1.3, 'alpha', 'Sulfur dioxide acidic vog haze envelope');
reg('cottonwood_fluff', 'atmospheric', [1.0, 1.0, 1.0, 0.65], 600, 2.2, 1.0, 0.5, 0.3, 5.5, 1.5, 'alpha', 'Summer tree seed fluff blizzard in breeze');
reg('cave_spores', 'atmospheric', [0.3, 0.8, 0.9, 0.8], 700, 0.8, 0.4, -0.1, 0.05, 5.0, 0.8, 'additive', 'Subterranean glowing cavern mycology spores');
reg('salt_spray', 'atmospheric', [0.85, 0.92, 0.98, 0.5], 2200, 14.0, 6.0, 6.0, 0.12, 2.0, 1.5, 'alpha', 'Coastal ocean wave crest aerosolized salt brine');
reg('steam_fog', 'atmospheric', [0.9, 0.92, 0.95, 0.45], 1400, 1.5, 0.5, -1.2, 0.12, 4.0, 0.9, 'alpha', 'Warm lake water vapor condensing into cold air');
reg('smoke_plume', 'atmospheric', [0.3, 0.3, 0.32, 0.8], 2200, 6.0, 2.0, -3.0, 0.1, 4.5, 1.6, 'alpha', 'Dark carbon soot industrial chimney smoke plume');
reg('algae_scum', 'atmospheric', [0.2, 0.6, 0.15, 0.8], 800, 0.6, 0.2, 0.0, 0.15, 6.0, 0.3, 'alpha', 'Eutrophic stagnant pond green surface mantle');
reg('frost_mist', 'atmospheric', [0.9, 0.95, 1.0, 0.5], 1500, 1.8, 0.6, 0.2, 0.1, 5.0, 0.8, 'alpha', 'Rime frost supercooled cloud droplet fog');
reg('pumice_fall', 'atmospheric', [0.75, 0.7, 0.65, 0.85], 1100, 8.0, 4.0, 12.0, 0.1, 3.0, 1.0, 'alpha', 'Lightweight porous volcanic stone lapilli rain');
reg('coral_spawn', 'atmospheric', [0.95, 0.5, 0.6, 0.8], 1600, 1.5, 0.5, -1.0, 0.1, 5.0, 0.7, 'additive', 'Synchronized nocturnal reef coral gamete cloud');
reg('hail_squall', 'atmospheric', [0.92, 0.96, 1.0, 0.85], 2800, 26.0, 6.0, 16.0, 0.06, 1.8, 1.6, 'alpha', 'Severe thunderstorm downdraft ice hail surge');
reg('desert_glare_haze', 'atmospheric', [0.95, 0.9, 0.7, 0.4], 900, 1.0, 0.3, 0.0, 0.1, 6.0, 0.5, 'alpha', 'White-hot solar bleached horizon dust veil');
reg('will_o_the_wisp', 'atmospheric', [0.2, 0.95, 0.7, 0.85], 400, 1.5, 0.8, -0.3, 0.05, 4.5, 1.9, 'additive', 'Ghostly marsh phosphine gas flame hovering');
reg('pollen_vortex', 'atmospheric', [0.9, 0.85, 0.3, 0.6], 1500, 7.0, 2.5, 0.0, 0.1, 4.0, 2.5, 'alpha', 'Whirling localized pollen dust devil spiral');
reg('arctic_diamond_dust', 'atmospheric', [0.95, 0.98, 1.0, 0.9], 1200, 1.0, 0.4, 1.0, 0.05, 5.0, 0.6, 'additive', 'Ground-level columnar ice crystal optical sun pillar');
reg('sulfur_vent', 'atmospheric', [0.85, 0.9, 0.2, 0.7], 1700, 10.0, 3.0, -2.0, 0.12, 3.2, 1.3, 'alpha', 'Volcanic fumarole yellow sulfurous gas plume');
reg('bioluminescent_tide', 'atmospheric', [0.0, 0.9, 0.8, 0.9], 3200, 6.0, 2.0, 2.0, 0.1, 3.0, 1.5, 'additive', 'Crashing coastal wave dynamic dinoflagellate blue glow');

export function getSpatialFXCount(): number {
  return Object.keys(SPATIAL_FX_CATALOGUE).length;
}

export function getSpatialFX(name: string): ParticleEffectDescriptor | undefined {
  const clean = name.replace(/^\$/, '').toLowerCase().replace(/-/g, '_');
  return SPATIAL_FX_CATALOGUE[clean] || Object.values(SPATIAL_FX_CATALOGUE).find(fx => fx.name.toLowerCase() === clean);
}

export function getSpatialFXByCategory(category: ParticleEffectDescriptor['category']): ParticleEffectDescriptor[] {
  return Object.values(SPATIAL_FX_CATALOGUE).filter(fx => fx.category === category);
}

export function searchSpatialFXByTag(keyword: string): ParticleEffectDescriptor[] {
  const query = keyword.toLowerCase();
  return Object.values(SPATIAL_FX_CATALOGUE).filter(
    fx => fx.name.toLowerCase().includes(query) || fx.description.toLowerCase().includes(query)
  );
}

