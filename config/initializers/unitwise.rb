# Unitwise.register(
#   names: ["pood"],
#   symbol: "pd",
#   primary_code: "pd",
#   secondary_code: "pd",
#   scale: {
#     value: 6138.00,
#     unit_code: 'g'
#   },
#   property: 'mass'
# )

Unitwise.register(
  names: ["shot", "shots", "shot of liquor", "shot of alcohol"],
  primary_code: "sht",
  secondary_code: "sht",
  scale: {
    value: 1.5,
    unit_code: '[foz_us]'
  },
  property: 'fluid volume'
)

Unitwise.register(
  names: ["wine", "glass of wine", "glasses of wine"],
  primary_code: "glsw",
  secondary_code: "glswn",
  scale: {
    value: 6.0,
    unit_code: '[foz_us]'
  },
  property: 'fluid volume'
)

Unitwise.register(
  names: ["beer", "beers", "glass of beer", "glasses of beer", "bottle of beer"],
  primary_code: "beer",
  scale: {
    value: 12.0,
    unit_code: '[foz_us]'
  },
  property: 'fluid volume'
)

Unitwise.register(
  names: ["soda", "sodas", "coke", "cokes", "pepsi", "pepsis", "can of soda", "pop"],
  primary_code: "soda",
  scale: {
    value: 12,
    unit_code: '[foz_us]'
  },
  property: 'fluid volume'
)

Unitwise.register(
  names: ["glass", "glasses"],
  primary_code: "gls",
  scale: {
    value: 8,
    unit_code: '[foz_us]'
  },
  property: 'fluid volume'
)