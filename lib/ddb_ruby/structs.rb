# This code may look unusually verbose for Ruby (and it is), but
# it performs some subtle and complex validation of JSON data.
#
# To parse this JSON, add 'dry-struct' and 'dry-types' gems, then do:
#
#   character = Character.from_json! "{…}"
#   puts character.optional_class_features.first
#
# If from_json! succeeds, the value returned matches the schema.

# require 'json'
# require 'dry-types'
# require 'dry-struct'

module DdbRuby
  module Types
    include Dry.Types(default: :nominal)

    Integer                = Coercible::Integer
    Bool                   = Types::Params::Bool
    Hash                   = Coercible::Hash
    String                 = Coercible::String
    Double                 = Coercible::Float | Coercible::Integer
    Restriction            = Coercible::String.enum("Concentration", "")
    EntityType             = Coercible::String.enum("class-feature")
    ContainerDefinitionKey = Coercible::String.enum("1581111423:53552888")
    FilterType             = Coercible::String.enum("Armor", "Other Gear", "Potion", "Weapon")
    Rarity                 = Coercible::String.enum("Common", "Rare", "Uncommon")
  end

  class Activation < Dry::Struct
    attribute :activation_time, Types::Integer.optional
    attribute :activation_type, Types::Integer.optional

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        activation_time: d.fetch("activationTime"),
        activation_type: d.fetch("activationType"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "activationTime" => activation_time,
        "activationType" => activation_type,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ClassLimitedUse < Dry::Struct
    attribute :limited_use_name,           Types::Nil
    attribute :stat_modifier_uses_id,      Types::Nil
    attribute :reset_type,                 Types::Integer
    attribute :number_used,                Types::Integer
    attribute :min_number_consumed,        Types::Integer
    attribute :max_number_consumed,        Types::Integer
    attribute :max_uses,                   Types::Integer
    attribute :operator,                   Types::Integer
    attribute :use_proficiency_bonus,      Types::Bool
    attribute :proficiency_bonus_operator, Types::Integer
    attribute :reset_dice,                 Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        limited_use_name:           d.fetch("name"),
        stat_modifier_uses_id:      d.fetch("statModifierUsesId"),
        reset_type:                 d.fetch("resetType"),
        number_used:                d.fetch("numberUsed"),
        min_number_consumed:        d.fetch("minNumberConsumed"),
        max_number_consumed:        d.fetch("maxNumberConsumed"),
        max_uses:                   d.fetch("maxUses"),
        operator:                   d.fetch("operator"),
        use_proficiency_bonus:      d.fetch("useProficiencyBonus"),
        proficiency_bonus_operator: d.fetch("proficiencyBonusOperator"),
        reset_dice:                 d.fetch("resetDice"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "name"                     => limited_use_name,
        "statModifierUsesId"       => stat_modifier_uses_id,
        "resetType"                => reset_type,
        "numberUsed"               => number_used,
        "minNumberConsumed"        => min_number_consumed,
        "maxNumberConsumed"        => max_number_consumed,
        "maxUses"                  => max_uses,
        "operator"                 => operator,
        "useProficiencyBonus"      => use_proficiency_bonus,
        "proficiencyBonusOperator" => proficiency_bonus_operator,
        "resetDice"                => reset_dice,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ClassRange < Dry::Struct
    attribute :range,                       Types::Nil
    attribute :long_range,                  Types::Nil
    attribute :aoe_type,                    Types::Nil
    attribute :aoe_size,                    Types::Nil
    attribute :has_aoe_special_description, Types::Bool
    attribute :minimum_range,               Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        range:                       d.fetch("range"),
        long_range:                  d.fetch("longRange"),
        aoe_type:                    d.fetch("aoeType"),
        aoe_size:                    d.fetch("aoeSize"),
        has_aoe_special_description: d.fetch("hasAoeSpecialDescription"),
        minimum_range:               d.fetch("minimumRange"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "range"                    => range,
        "longRange"                => long_range,
        "aoeType"                  => aoe_type,
        "aoeSize"                  => aoe_size,
        "hasAoeSpecialDescription" => has_aoe_special_description,
        "minimumRange"             => minimum_range,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ActionsClass < Dry::Struct
    attribute :component_id,             Types::Integer
    attribute :component_type_id,        Types::Integer
    attribute :id,                       Types::String
    attribute :entity_type_id,           Types::String
    attribute :limited_use,              ClassLimitedUse.optional
    attribute :class_name,               Types::String
    attribute :description,              Types::String.optional
    attribute :snippet,                  Types::String
    attribute :ability_modifier_stat_id, Types::Nil
    attribute :on_miss_description,      Types::String.optional
    attribute :save_fail_description,    Types::String.optional
    attribute :save_success_description, Types::String.optional
    attribute :save_stat_id,             Types::Nil
    attribute :fixed_save_dc,            Types::Nil
    attribute :attack_type_range,        Types::Nil
    attribute :action_type,              Types::Integer
    attribute :attack_subtype,           Types::Nil
    attribute :dice,                     Types::Nil
    attribute :value,                    Types::Nil
    attribute :damage_type_id,           Types::Nil
    attribute :is_martial_arts,          Types::Bool
    attribute :is_proficient,            Types::Bool
    attribute :spell_range_type,         Types::Nil
    attribute :display_as_attack,        Types::Nil
    attribute :range,                    ClassRange
    attribute :activation,               Activation
    attribute :number_of_targets,        Types::Nil
    attribute :fixed_to_hit,             Types::Nil
    attribute :ammunition,               Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        component_id:             d.fetch("componentId"),
        component_type_id:        d.fetch("componentTypeId"),
        id:                       d.fetch("id"),
        entity_type_id:           d.fetch("entityTypeId"),
        limited_use:              d.fetch("limitedUse") ? ClassLimitedUse.from_dynamic!(d.fetch("limitedUse")) : nil,
        class_name:               d.fetch("name"),
        description:              d.fetch("description"),
        snippet:                  d.fetch("snippet"),
        ability_modifier_stat_id: d.fetch("abilityModifierStatId"),
        on_miss_description:      d.fetch("onMissDescription"),
        save_fail_description:    d.fetch("saveFailDescription"),
        save_success_description: d.fetch("saveSuccessDescription"),
        save_stat_id:             d.fetch("saveStatId"),
        fixed_save_dc:            d.fetch("fixedSaveDc"),
        attack_type_range:        d.fetch("attackTypeRange"),
        action_type:              d.fetch("actionType"),
        attack_subtype:           d.fetch("attackSubtype"),
        dice:                     d.fetch("dice"),
        value:                    d.fetch("value"),
        damage_type_id:           d.fetch("damageTypeId"),
        is_martial_arts:          d.fetch("isMartialArts"),
        is_proficient:            d.fetch("isProficient"),
        spell_range_type:         d.fetch("spellRangeType"),
        display_as_attack:        d.fetch("displayAsAttack"),
        range:                    ClassRange.from_dynamic!(d.fetch("range")),
        activation:               Activation.from_dynamic!(d.fetch("activation")),
        number_of_targets:        d.fetch("numberOfTargets"),
        fixed_to_hit:             d.fetch("fixedToHit"),
        ammunition:               d.fetch("ammunition"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "componentId"            => component_id,
        "componentTypeId"        => component_type_id,
        "id"                     => id,
        "entityTypeId"           => entity_type_id,
        "limitedUse"             => limited_use&.to_dynamic,
        "name"                   => class_name,
        "description"            => description,
        "snippet"                => snippet,
        "abilityModifierStatId"  => ability_modifier_stat_id,
        "onMissDescription"      => on_miss_description,
        "saveFailDescription"    => save_fail_description,
        "saveSuccessDescription" => save_success_description,
        "saveStatId"             => save_stat_id,
        "fixedSaveDc"            => fixed_save_dc,
        "attackTypeRange"        => attack_type_range,
        "actionType"             => action_type,
        "attackSubtype"          => attack_subtype,
        "dice"                   => dice,
        "value"                  => value,
        "damageTypeId"           => damage_type_id,
        "isMartialArts"          => is_martial_arts,
        "isProficient"           => is_proficient,
        "spellRangeType"         => spell_range_type,
        "displayAsAttack"        => display_as_attack,
        "range"                  => range.to_dynamic,
        "activation"             => activation.to_dynamic,
        "numberOfTargets"        => number_of_targets,
        "fixedToHit"             => fixed_to_hit,
        "ammunition"             => ammunition,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class HigherLevelDefinition < Dry::Struct
    attribute :level,   Types::Integer
    attribute :type_id, Types::Integer
    attribute :dice,    Types::Nil
    attribute :value,   Types::Integer
    attribute :details, Types::String

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        level:   d.fetch("level"),
        type_id: d.fetch("typeId"),
        dice:    d.fetch("dice"),
        value:   d.fetch("value"),
        details: d.fetch("details"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "level"   => level,
        "typeId"  => type_id,
        "dice"    => dice,
        "value"   => value,
        "details" => details,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class AtHigherLevels < Dry::Struct
    attribute :higher_level_definitions, Types.Array(HigherLevelDefinition)
    attribute :additional_attacks,       Types.Array(Types::Any)
    attribute :additional_targets,       Types.Array(Types::Any)
    attribute :area_of_effect,           Types.Array(Types::Any)
    attribute :duration,                 Types.Array(Types::Any)
    attribute :creatures,                Types.Array(Types::Any)
    attribute :special,                  Types.Array(Types::Any)
    attribute :points,                   Types.Array(Types::Any)
    attribute :range,                    Types.Array(Types::Any)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        higher_level_definitions: d.fetch("higherLevelDefinitions").map { |x| HigherLevelDefinition.from_dynamic!(x) },
        additional_attacks:       d.fetch("additionalAttacks"),
        additional_targets:       d.fetch("additionalTargets"),
        area_of_effect:           d.fetch("areaOfEffect"),
        duration:                 d.fetch("duration"),
        creatures:                d.fetch("creatures"),
        special:                  d.fetch("special"),
        points:                   d.fetch("points"),
        range:                    d.fetch("range"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "higherLevelDefinitions" => higher_level_definitions.map { |x| x.to_dynamic },
        "additionalAttacks"      => additional_attacks,
        "additionalTargets"      => additional_targets,
        "areaOfEffect"           => area_of_effect,
        "duration"               => duration,
        "creatures"              => creatures,
        "special"                => special,
        "points"                 => points,
        "range"                  => range,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  module Restriction
    Concentration = "Concentration"
    Empty         = ""
  end

  class DefinitionDuration < Dry::Struct
    attribute :duration_interval, Types::Integer
    attribute :duration_unit,     Types::String
    attribute :duration_type,     Types::Restriction

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        duration_interval: d.fetch("durationInterval"),
        duration_unit:     d.fetch("durationUnit"),
        duration_type:     d.fetch("durationType"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "durationInterval" => duration_interval,
        "durationUnit"     => duration_unit,
        "durationType"     => duration_type,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Die < Dry::Struct
    attribute :dice_count,      Types::Integer.optional
    attribute :dice_value,      Types::Integer.optional
    attribute :dice_multiplier, Types::Integer.optional
    attribute :fixed_value,     Types::Integer.optional
    attribute :dice_string,     Types::String.optional

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        dice_count:      d.fetch("diceCount"),
        dice_value:      d.fetch("diceValue"),
        dice_multiplier: d.fetch("diceMultiplier"),
        fixed_value:     d.fetch("fixedValue"),
        dice_string:     d.fetch("diceString"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "diceCount"      => dice_count,
        "diceValue"      => dice_value,
        "diceMultiplier" => dice_multiplier,
        "fixedValue"     => fixed_value,
        "diceString"     => dice_string,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class BackgroundDuration < Dry::Struct
    attribute :duration_interval, Types::Integer
    attribute :duration_unit,     Types::String

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        duration_interval: d.fetch("durationInterval"),
        duration_unit:     d.fetch("durationUnit"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "durationInterval" => duration_interval,
        "durationUnit"     => duration_unit,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ItemElement < Dry::Struct
    attribute :fixed_value,             Types::Integer.optional
    attribute :id,                      Types::String
    attribute :entity_id,               Types::Integer.optional
    attribute :entity_type_id,          Types::Integer.optional
    attribute :background_type,         Types::String
    attribute :sub_type,                Types::String
    attribute :dice,                    Die.optional
    attribute :restriction,             Types::Restriction.optional
    attribute :stat_id,                 Types::Nil
    attribute :requires_attunement,     Types::Bool
    attribute :duration,                BackgroundDuration.optional
    attribute :friendly_type_name,      Types::String
    attribute :friendly_subtype_name,   Types::String
    attribute :is_granted,              Types::Bool
    attribute :bonus_types,             Types.Array(Types::Any)
    attribute :value,                   Types::Integer.optional
    attribute :available_to_multiclass, Types::Bool.optional
    attribute :modifier_type_id,        Types::Integer
    attribute :modifier_sub_type_id,    Types::Integer
    attribute :component_id,            Types::Integer
    attribute :component_type_id,       Types::Integer
    attribute :die,                     Die.optional
    attribute :count,                   Types::Integer.optional
    attribute :duration_unit,           Types::Nil.optional
    attribute :use_primary_stat,        Types::Bool.optional
    attribute :at_higher_levels,        AtHigherLevels.optional

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        fixed_value:             d.fetch("fixedValue"),
        id:                      d.fetch("id"),
        entity_id:               d.fetch("entityId"),
        entity_type_id:          d.fetch("entityTypeId"),
        background_type:         d.fetch("type"),
        sub_type:                d.fetch("subType"),
        dice:                    d.fetch("dice") ? Die.from_dynamic!(d.fetch("dice")) : nil,
        restriction:             d.fetch("restriction"),
        stat_id:                 d.fetch("statId"),
        requires_attunement:     d.fetch("requiresAttunement"),
        duration:                d.fetch("duration") ? BackgroundDuration.from_dynamic!(d.fetch("duration")) : nil,
        friendly_type_name:      d.fetch("friendlyTypeName"),
        friendly_subtype_name:   d.fetch("friendlySubtypeName"),
        is_granted:              d.fetch("isGranted"),
        bonus_types:             d.fetch("bonusTypes"),
        value:                   d.fetch("value"),
        available_to_multiclass: d.fetch("availableToMulticlass"),
        modifier_type_id:        d.fetch("modifierTypeId"),
        modifier_sub_type_id:    d.fetch("modifierSubTypeId"),
        component_id:            d.fetch("componentId"),
        component_type_id:       d.fetch("componentTypeId"),
        die:                     d["die"] ? Die.from_dynamic!(d["die"]) : nil,
        count:                   d["count"],
        duration_unit:           d["durationUnit"],
        use_primary_stat:        d["usePrimaryStat"],
        at_higher_levels:        d["atHigherLevels"] ? AtHigherLevels.from_dynamic!(d["atHigherLevels"]) : nil,
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "fixedValue"            => fixed_value,
        "id"                    => id,
        "entityId"              => entity_id,
        "entityTypeId"          => entity_type_id,
        "type"                  => background_type,
        "subType"               => sub_type,
        "dice"                  => dice&.to_dynamic,
        "restriction"           => restriction,
        "statId"                => stat_id,
        "requiresAttunement"    => requires_attunement,
        "duration"              => duration&.to_dynamic,
        "friendlyTypeName"      => friendly_type_name,
        "friendlySubtypeName"   => friendly_subtype_name,
        "isGranted"             => is_granted,
        "bonusTypes"            => bonus_types,
        "value"                 => value,
        "availableToMulticlass" => available_to_multiclass,
        "modifierTypeId"        => modifier_type_id,
        "modifierSubTypeId"     => modifier_sub_type_id,
        "componentId"           => component_id,
        "componentTypeId"       => component_type_id,
        "die"                   => die&.to_dynamic,
        "count"                 => count,
        "durationUnit"          => duration_unit,
        "usePrimaryStat"        => use_primary_stat,
        "atHigherLevels"        => at_higher_levels&.to_dynamic,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class DefinitionRange < Dry::Struct
    attribute :origin,      Types::String
    attribute :range_value, Types::Integer
    attribute :aoe_type,    Types::Nil
    attribute :aoe_value,   Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        origin:      d.fetch("origin"),
        range_value: d.fetch("rangeValue"),
        aoe_type:    d.fetch("aoeType"),
        aoe_value:   d.fetch("aoeValue"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "origin"     => origin,
        "rangeValue" => range_value,
        "aoeType"    => aoe_type,
        "aoeValue"   => aoe_value,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Source < Dry::Struct
    attribute :source_id,   Types::Integer
    attribute :page_number, Types::Integer.optional
    attribute :source_type, Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        source_id:   d.fetch("sourceId"),
        page_number: d.fetch("pageNumber"),
        source_type: d.fetch("sourceType"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "sourceId"   => source_id,
        "pageNumber" => page_number,
        "sourceType" => source_type,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ItemDefinition < Dry::Struct
    attribute :id,                       Types::Integer
    attribute :definition_key,           Types::String
    attribute :definition_name,          Types::String
    attribute :level,                    Types::Integer
    attribute :school,                   Types::String
    attribute :duration,                 DefinitionDuration
    attribute :activation,               Activation
    attribute :range,                    DefinitionRange
    attribute :as_part_of_weapon_attack, Types::Bool
    attribute :description,              Types::String
    attribute :snippet,                  Types::String
    attribute :concentration,            Types::Bool
    attribute :ritual,                   Types::Bool
    attribute :range_area,               Types::Nil
    attribute :damage_effect,            Types::Nil
    attribute :components,               Types.Array(Types::Integer)
    attribute :components_description,   Types::String
    attribute :save_dc_ability_id,       Types::Nil
    attribute :healing,                  Types::Nil
    attribute :healing_dice,             Types.Array(Types::Any)
    attribute :temp_hp_dice,             Types.Array(Types::Any)
    attribute :attack_type,              Types::Nil
    attribute :can_cast_at_higher_level, Types::Bool
    attribute :is_homebrew,              Types::Bool
    attribute :version,                  Types::Nil
    attribute :source_id,                Types::Nil
    attribute :source_page_number,       Types::Integer
    attribute :requires_saving_throw,    Types::Bool
    attribute :requires_attack_roll,     Types::Bool
    attribute :at_higher_levels,         AtHigherLevels
    attribute :modifiers,                Types.Array(ItemElement)
    attribute :conditions,               Types.Array(Types::Any)
    attribute :tags,                     Types.Array(Types::String)
    attribute :casting_time_description, Types::String
    attribute :scale_type,               Types::String
    attribute :sources,                  Types.Array(Source)
    attribute :spell_groups,             Types.Array(Types::Any)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                       d.fetch("id"),
        definition_key:           d.fetch("definitionKey"),
        definition_name:          d.fetch("name"),
        level:                    d.fetch("level"),
        school:                   d.fetch("school"),
        duration:                 DefinitionDuration.from_dynamic!(d.fetch("duration")),
        activation:               Activation.from_dynamic!(d.fetch("activation")),
        range:                    DefinitionRange.from_dynamic!(d.fetch("range")),
        as_part_of_weapon_attack: d.fetch("asPartOfWeaponAttack"),
        description:              d.fetch("description"),
        snippet:                  d.fetch("snippet"),
        concentration:            d.fetch("concentration"),
        ritual:                   d.fetch("ritual"),
        range_area:               d.fetch("rangeArea"),
        damage_effect:            d.fetch("damageEffect"),
        components:               d.fetch("components"),
        components_description:   d.fetch("componentsDescription"),
        save_dc_ability_id:       d.fetch("saveDcAbilityId"),
        healing:                  d.fetch("healing"),
        healing_dice:             d.fetch("healingDice"),
        temp_hp_dice:             d.fetch("tempHpDice"),
        attack_type:              d.fetch("attackType"),
        can_cast_at_higher_level: d.fetch("canCastAtHigherLevel"),
        is_homebrew:              d.fetch("isHomebrew"),
        version:                  d.fetch("version"),
        source_id:                d.fetch("sourceId"),
        source_page_number:       d.fetch("sourcePageNumber"),
        requires_saving_throw:    d.fetch("requiresSavingThrow"),
        requires_attack_roll:     d.fetch("requiresAttackRoll"),
        at_higher_levels:         AtHigherLevels.from_dynamic!(d.fetch("atHigherLevels")),
        modifiers:                d.fetch("modifiers").map { |x| ItemElement.from_dynamic!(x) },
        conditions:               d.fetch("conditions"),
        tags:                     d.fetch("tags"),
        casting_time_description: d.fetch("castingTimeDescription"),
        scale_type:               d.fetch("scaleType"),
        sources:                  d.fetch("sources").map { |x| Source.from_dynamic!(x) },
        spell_groups:             d.fetch("spellGroups"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                     => id,
        "definitionKey"          => definition_key,
        "name"                   => definition_name,
        "level"                  => level,
        "school"                 => school,
        "duration"               => duration.to_dynamic,
        "activation"             => activation.to_dynamic,
        "range"                  => range.to_dynamic,
        "asPartOfWeaponAttack"   => as_part_of_weapon_attack,
        "description"            => description,
        "snippet"                => snippet,
        "concentration"          => concentration,
        "ritual"                 => ritual,
        "rangeArea"              => range_area,
        "damageEffect"           => damage_effect,
        "components"             => components,
        "componentsDescription"  => components_description,
        "saveDcAbilityId"        => save_dc_ability_id,
        "healing"                => healing,
        "healingDice"            => healing_dice,
        "tempHpDice"             => temp_hp_dice,
        "attackType"             => attack_type,
        "canCastAtHigherLevel"   => can_cast_at_higher_level,
        "isHomebrew"             => is_homebrew,
        "version"                => version,
        "sourceId"               => source_id,
        "sourcePageNumber"       => source_page_number,
        "requiresSavingThrow"    => requires_saving_throw,
        "requiresAttackRoll"     => requires_attack_roll,
        "atHigherLevels"         => at_higher_levels.to_dynamic,
        "modifiers"              => modifiers.map { |x| x.to_dynamic },
        "conditions"             => conditions,
        "tags"                   => tags,
        "castingTimeDescription" => casting_time_description,
        "scaleType"              => scale_type,
        "sources"                => sources.map { |x| x.to_dynamic },
        "spellGroups"            => spell_groups,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Item < Dry::Struct
    attribute :override_save_dc,          Types::Nil
    attribute :limited_use,               Types::Nil
    attribute :id,                        Types::Integer
    attribute :entity_type_id,            Types::Integer
    attribute :definition,                ItemDefinition
    attribute :definition_id,             Types::Integer
    attribute :prepared,                  Types::Bool
    attribute :counts_as_known_spell,     Types::Nil
    attribute :uses_spell_slot,           Types::Bool
    attribute :cast_at_level,             Types::Nil
    attribute :always_prepared,           Types::Bool
    attribute :restriction,               Types::Nil
    attribute :spell_casting_ability_id,  Types::Nil
    attribute :display_as_attack,         Types::Bool
    attribute :additional_description,    Types::Nil
    attribute :cast_only_as_ritual,       Types::Bool
    attribute :ritual_casting_type,       Types::Nil
    attribute :range,                     DefinitionRange
    attribute :activation,                Activation
    attribute :base_level_at_will,        Types::Bool
    attribute :at_will_limited_use_level, Types::Nil
    attribute :is_signature_spell,        Types::Nil
    attribute :component_id,              Types::Integer
    attribute :component_type_id,         Types::Integer
    attribute :spell_list_id,             Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        override_save_dc:          d.fetch("overrideSaveDc"),
        limited_use:               d.fetch("limitedUse"),
        id:                        d.fetch("id"),
        entity_type_id:            d.fetch("entityTypeId"),
        definition:                ItemDefinition.from_dynamic!(d.fetch("definition")),
        definition_id:             d.fetch("definitionId"),
        prepared:                  d.fetch("prepared"),
        counts_as_known_spell:     d.fetch("countsAsKnownSpell"),
        uses_spell_slot:           d.fetch("usesSpellSlot"),
        cast_at_level:             d.fetch("castAtLevel"),
        always_prepared:           d.fetch("alwaysPrepared"),
        restriction:               d.fetch("restriction"),
        spell_casting_ability_id:  d.fetch("spellCastingAbilityId"),
        display_as_attack:         d.fetch("displayAsAttack"),
        additional_description:    d.fetch("additionalDescription"),
        cast_only_as_ritual:       d.fetch("castOnlyAsRitual"),
        ritual_casting_type:       d.fetch("ritualCastingType"),
        range:                     DefinitionRange.from_dynamic!(d.fetch("range")),
        activation:                Activation.from_dynamic!(d.fetch("activation")),
        base_level_at_will:        d.fetch("baseLevelAtWill"),
        at_will_limited_use_level: d.fetch("atWillLimitedUseLevel"),
        is_signature_spell:        d.fetch("isSignatureSpell"),
        component_id:              d.fetch("componentId"),
        component_type_id:         d.fetch("componentTypeId"),
        spell_list_id:             d.fetch("spellListId"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "overrideSaveDc"        => override_save_dc,
        "limitedUse"            => limited_use,
        "id"                    => id,
        "entityTypeId"          => entity_type_id,
        "definition"            => definition.to_dynamic,
        "definitionId"          => definition_id,
        "prepared"              => prepared,
        "countsAsKnownSpell"    => counts_as_known_spell,
        "usesSpellSlot"         => uses_spell_slot,
        "castAtLevel"           => cast_at_level,
        "alwaysPrepared"        => always_prepared,
        "restriction"           => restriction,
        "spellCastingAbilityId" => spell_casting_ability_id,
        "displayAsAttack"       => display_as_attack,
        "additionalDescription" => additional_description,
        "castOnlyAsRitual"      => cast_only_as_ritual,
        "ritualCastingType"     => ritual_casting_type,
        "range"                 => range.to_dynamic,
        "activation"            => activation.to_dynamic,
        "baseLevelAtWill"       => base_level_at_will,
        "atWillLimitedUseLevel" => at_will_limited_use_level,
        "isSignatureSpell"      => is_signature_spell,
        "componentId"           => component_id,
        "componentTypeId"       => component_type_id,
        "spellListId"           => spell_list_id,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Actions < Dry::Struct
    attribute :race,          Types.Array(Types::Any)
    attribute :actions_class, Types.Array(ActionsClass)
    attribute :background,    Types::Nil
    attribute :item,          Types.Array(Item).optional
    attribute :feat,          Types.Array(Types::Any)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        race:          d.fetch("race"),
        actions_class: d.fetch("class").map { |x| ActionsClass.from_dynamic!(x) },
        background:    d.fetch("background"),
        item:          d.fetch("item")&.map { |x| Item.from_dynamic!(x) },
        feat:          d.fetch("feat"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "race"       => race,
        "class"      => actions_class.map { |x| x.to_dynamic },
        "background" => background,
        "item"       => item&.map { |x| x.to_dynamic },
        "feat"       => feat,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class CustomBackground < Dry::Struct
    attribute :id,                                       Types::Integer
    attribute :entity_type_id,                           Types::Integer
    attribute :custom_background_name,                   Types::Nil
    attribute :description,                              Types::Nil
    attribute :features_background,                      Types::Nil
    attribute :characteristics_background,               Types::Nil
    attribute :features_background_definition_id,        Types::Nil
    attribute :characteristics_background_definition_id, Types::Nil
    attribute :background_type,                          Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                                       d.fetch("id"),
        entity_type_id:                           d.fetch("entityTypeId"),
        custom_background_name:                   d.fetch("name"),
        description:                              d.fetch("description"),
        features_background:                      d.fetch("featuresBackground"),
        characteristics_background:               d.fetch("characteristicsBackground"),
        features_background_definition_id:        d.fetch("featuresBackgroundDefinitionId"),
        characteristics_background_definition_id: d.fetch("characteristicsBackgroundDefinitionId"),
        background_type:                          d.fetch("backgroundType"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                                    => id,
        "entityTypeId"                          => entity_type_id,
        "name"                                  => custom_background_name,
        "description"                           => description,
        "featuresBackground"                    => features_background,
        "characteristicsBackground"             => characteristics_background,
        "featuresBackgroundDefinitionId"        => features_background_definition_id,
        "characteristicsBackgroundDefinitionId" => characteristics_background_definition_id,
        "backgroundType"                        => background_type,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Bond < Dry::Struct
    attribute :id,          Types::Integer
    attribute :description, Types::String
    attribute :dice_roll,   Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:          d.fetch("id"),
        description: d.fetch("description"),
        dice_roll:   d.fetch("diceRoll"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"          => id,
        "description" => description,
        "diceRoll"    => dice_roll,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class BackgroundDefinition < Dry::Struct
    attribute :id,                                    Types::Integer
    attribute :entity_type_id,                        Types::Integer
    attribute :definition_key,                        Types::String
    attribute :definition_name,                       Types::String
    attribute :description,                           Types::String
    attribute :snippet,                               Types::String
    attribute :short_description,                     Types::String
    attribute :skill_proficiencies_description,       Types::String
    attribute :tool_proficiencies_description,        Types::String
    attribute :languages_description,                 Types::String
    attribute :equipment_description,                 Types::String
    attribute :feature_name,                          Types::String
    attribute :feature_description,                   Types::String
    attribute :avatar_url,                            Types::Nil
    attribute :large_avatar_url,                      Types::Nil
    attribute :suggested_characteristics_description, Types::String
    attribute :suggested_proficiencies,               Types::Nil
    attribute :suggested_languages,                   Types::Nil
    attribute :organization,                          Types::Nil
    attribute :contracts_description,                 Types::String
    attribute :spells_pre_description,                Types::String
    attribute :spells_post_description,               Types::String
    attribute :personality_traits,                    Types.Array(Bond)
    attribute :ideals,                                Types.Array(Bond)
    attribute :bonds,                                 Types.Array(Bond)
    attribute :flaws,                                 Types.Array(Bond)
    attribute :is_homebrew,                           Types::Bool
    attribute :sources,                               Types.Array(Source)
    attribute :spell_list_ids,                        Types.Array(Types::Any)
    attribute :feat_list,                             Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                                    d.fetch("id"),
        entity_type_id:                        d.fetch("entityTypeId"),
        definition_key:                        d.fetch("definitionKey"),
        definition_name:                       d.fetch("name"),
        description:                           d.fetch("description"),
        snippet:                               d.fetch("snippet"),
        short_description:                     d.fetch("shortDescription"),
        skill_proficiencies_description:       d.fetch("skillProficienciesDescription"),
        tool_proficiencies_description:        d.fetch("toolProficienciesDescription"),
        languages_description:                 d.fetch("languagesDescription"),
        equipment_description:                 d.fetch("equipmentDescription"),
        feature_name:                          d.fetch("featureName"),
        feature_description:                   d.fetch("featureDescription"),
        avatar_url:                            d.fetch("avatarUrl"),
        large_avatar_url:                      d.fetch("largeAvatarUrl"),
        suggested_characteristics_description: d.fetch("suggestedCharacteristicsDescription"),
        suggested_proficiencies:               d.fetch("suggestedProficiencies"),
        suggested_languages:                   d.fetch("suggestedLanguages"),
        organization:                          d.fetch("organization"),
        contracts_description:                 d.fetch("contractsDescription"),
        spells_pre_description:                d.fetch("spellsPreDescription"),
        spells_post_description:               d.fetch("spellsPostDescription"),
        personality_traits:                    d.fetch("personalityTraits").map { |x| Bond.from_dynamic!(x) },
        ideals:                                d.fetch("ideals").map { |x| Bond.from_dynamic!(x) },
        bonds:                                 d.fetch("bonds").map { |x| Bond.from_dynamic!(x) },
        flaws:                                 d.fetch("flaws").map { |x| Bond.from_dynamic!(x) },
        is_homebrew:                           d.fetch("isHomebrew"),
        sources:                               d.fetch("sources").map { |x| Source.from_dynamic!(x) },
        spell_list_ids:                        d.fetch("spellListIds"),
        feat_list:                             d.fetch("featList"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                                  => id,
        "entityTypeId"                        => entity_type_id,
        "definitionKey"                       => definition_key,
        "name"                                => definition_name,
        "description"                         => description,
        "snippet"                             => snippet,
        "shortDescription"                    => short_description,
        "skillProficienciesDescription"       => skill_proficiencies_description,
        "toolProficienciesDescription"        => tool_proficiencies_description,
        "languagesDescription"                => languages_description,
        "equipmentDescription"                => equipment_description,
        "featureName"                         => feature_name,
        "featureDescription"                  => feature_description,
        "avatarUrl"                           => avatar_url,
        "largeAvatarUrl"                      => large_avatar_url,
        "suggestedCharacteristicsDescription" => suggested_characteristics_description,
        "suggestedProficiencies"              => suggested_proficiencies,
        "suggestedLanguages"                  => suggested_languages,
        "organization"                        => organization,
        "contractsDescription"                => contracts_description,
        "spellsPreDescription"                => spells_pre_description,
        "spellsPostDescription"               => spells_post_description,
        "personalityTraits"                   => personality_traits.map { |x| x.to_dynamic },
        "ideals"                              => ideals.map { |x| x.to_dynamic },
        "bonds"                               => bonds.map { |x| x.to_dynamic },
        "flaws"                               => flaws.map { |x| x.to_dynamic },
        "isHomebrew"                          => is_homebrew,
        "sources"                             => sources.map { |x| x.to_dynamic },
        "spellListIds"                        => spell_list_ids,
        "featList"                            => feat_list,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class CharacterBackground < Dry::Struct
    attribute :has_custom_background, Types::Bool
    attribute :definition,            BackgroundDefinition
    attribute :definition_id,         Types::Nil
    attribute :custom_background,     CustomBackground

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        has_custom_background: d.fetch("hasCustomBackground"),
        definition:            BackgroundDefinition.from_dynamic!(d.fetch("definition")),
        definition_id:         d.fetch("definitionId"),
        custom_background:     CustomBackground.from_dynamic!(d.fetch("customBackground")),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "hasCustomBackground" => has_custom_background,
        "definition"          => definition.to_dynamic,
        "definitionId"        => definition_id,
        "customBackground"    => custom_background.to_dynamic,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Stat < Dry::Struct
    attribute :id,        Types::Integer
    attribute :stat_name, Types::Nil
    attribute :value,     Types::Integer.optional

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:        d.fetch("id"),
        stat_name: d.fetch("name"),
        value:     d.fetch("value"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"    => id,
        "name"  => stat_name,
        "value" => value,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class CharacterElement < Dry::Struct
    attribute :user_id,        Types::Integer
    attribute :username,       Types::String
    attribute :character_id,   Types::Integer
    attribute :character_name, Types::String
    attribute :character_url,  Types::String
    attribute :avatar_url,     Types::String.optional
    attribute :privacy_type,   Types::Integer
    attribute :campaign_id,    Types::Nil
    attribute :is_assigned,    Types::Bool

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        user_id:        d.fetch("userId"),
        username:       d.fetch("username"),
        character_id:   d.fetch("characterId"),
        character_name: d.fetch("characterName"),
        character_url:  d.fetch("characterUrl"),
        avatar_url:     d.fetch("avatarUrl"),
        privacy_type:   d.fetch("privacyType"),
        campaign_id:    d.fetch("campaignId"),
        is_assigned:    d.fetch("isAssigned"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "userId"        => user_id,
        "username"      => username,
        "characterId"   => character_id,
        "characterName" => character_name,
        "characterUrl"  => character_url,
        "avatarUrl"     => avatar_url,
        "privacyType"   => privacy_type,
        "campaignId"    => campaign_id,
        "isAssigned"    => is_assigned,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Campaign < Dry::Struct
    attribute :id,            Types::Integer
    attribute :campaign_name, Types::String
    attribute :description,   Types::String
    attribute :link,          Types::String
    attribute :public_notes,  Types::String
    attribute :dm_user_id,    Types::Integer
    attribute :dm_username,   Types::String
    attribute :characters,    Types.Array(CharacterElement)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:            d.fetch("id"),
        campaign_name: d.fetch("name"),
        description:   d.fetch("description"),
        link:          d.fetch("link"),
        public_notes:  d.fetch("publicNotes"),
        dm_user_id:    d.fetch("dmUserId"),
        dm_username:   d.fetch("dmUsername"),
        characters:    d.fetch("characters").map { |x| CharacterElement.from_dynamic!(x) },
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"          => id,
        "name"        => campaign_name,
        "description" => description,
        "link"        => link,
        "publicNotes" => public_notes,
        "dmUserId"    => dm_user_id,
        "dmUsername"  => dm_username,
        "characters"  => characters.map { |x| x.to_dynamic },
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Definition1 < Dry::Struct
    attribute :id,                 Types::Integer
    attribute :entity_type_id,     Types::Integer
    attribute :definition_name,    Types::String
    attribute :description,        Types::String
    attribute :snippet,            Types::String
    attribute :activation,         Types::Nil
    attribute :source_id,          Types::Integer
    attribute :source_page_number, Types::Nil
    attribute :creature_rules,     Types.Array(Types::Any)
    attribute :spell_list_ids,     Types.Array(Types::Any)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                 d.fetch("id"),
        entity_type_id:     d.fetch("entityTypeId"),
        definition_name:    d.fetch("name"),
        description:        d.fetch("description"),
        snippet:            d.fetch("snippet"),
        activation:         d.fetch("activation"),
        source_id:          d.fetch("sourceId"),
        source_page_number: d.fetch("sourcePageNumber"),
        creature_rules:     d.fetch("creatureRules"),
        spell_list_ids:     d.fetch("spellListIds"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"               => id,
        "entityTypeId"     => entity_type_id,
        "name"             => definition_name,
        "description"      => description,
        "snippet"          => snippet,
        "activation"       => activation,
        "sourceId"         => source_id,
        "sourcePageNumber" => source_page_number,
        "creatureRules"    => creature_rules,
        "spellListIds"     => spell_list_ids,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class OptionsClass < Dry::Struct
    attribute :component_id,      Types::Integer
    attribute :component_type_id, Types::Integer
    attribute :definition,        Definition1

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        component_id:      d.fetch("componentId"),
        component_type_id: d.fetch("componentTypeId"),
        definition:        Definition1.from_dynamic!(d.fetch("definition")),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "componentId"     => component_id,
        "componentTypeId" => component_type_id,
        "definition"      => definition.to_dynamic,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Options < Dry::Struct
    attribute :race,          Types.Array(Types::Any)
    attribute :options_class, Types.Array(OptionsClass)
    attribute :background,    Types::Nil
    attribute :item,          Types::Nil
    attribute :feat,          Types.Array(Types::Any)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        race:          d.fetch("race"),
        options_class: d.fetch("class").map { |x| OptionsClass.from_dynamic!(x) },
        background:    d.fetch("background"),
        item:          d.fetch("item"),
        feat:          d.fetch("feat"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "race"       => race,
        "class"      => options_class.map { |x| x.to_dynamic },
        "background" => background,
        "item"       => item,
        "feat"       => feat,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ChoicesBackground < Dry::Struct
    attribute :component_id,       Types::Integer
    attribute :component_type_id,  Types::Integer
    attribute :id,                 Types::String
    attribute :parent_choice_id,   Types::String.optional
    attribute :background_type,    Types::Integer
    attribute :sub_type,           Types::Integer.optional
    attribute :option_value,       Types::Integer
    attribute :label,              Types::String.optional
    attribute :is_optional,        Types::Bool
    attribute :is_infinite,        Types::Bool
    attribute :default_subtypes,   Types.Array(Types::String)
    attribute :display_order,      Types::Nil
    attribute :background_options, Types.Array(Types::Any)
    attribute :option_ids,         Types.Array(Types::Integer)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        component_id:       d.fetch("componentId"),
        component_type_id:  d.fetch("componentTypeId"),
        id:                 d.fetch("id"),
        parent_choice_id:   d.fetch("parentChoiceId"),
        background_type:    d.fetch("type"),
        sub_type:           d.fetch("subType"),
        option_value:       d.fetch("optionValue"),
        label:              d.fetch("label"),
        is_optional:        d.fetch("isOptional"),
        is_infinite:        d.fetch("isInfinite"),
        default_subtypes:   d.fetch("defaultSubtypes"),
        display_order:      d.fetch("displayOrder"),
        background_options: d.fetch("options"),
        option_ids:         d.fetch("optionIds"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "componentId"     => component_id,
        "componentTypeId" => component_type_id,
        "id"              => id,
        "parentChoiceId"  => parent_choice_id,
        "type"            => background_type,
        "subType"         => sub_type,
        "optionValue"     => option_value,
        "label"           => label,
        "isOptional"      => is_optional,
        "isInfinite"      => is_infinite,
        "defaultSubtypes" => default_subtypes,
        "displayOrder"    => display_order,
        "options"         => background_options,
        "optionIds"       => option_ids,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Option < Dry::Struct
    attribute :id,          Types::Integer
    attribute :label,       Types::String
    attribute :description, Types::String.optional

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:          d.fetch("id"),
        label:       d.fetch("label"),
        description: d.fetch("description"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"          => id,
        "label"       => label,
        "description" => description,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ChoiceDefinition < Dry::Struct
    attribute :id,                        Types::String
    attribute :choice_definition_options, Types.Array(Option)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                        d.fetch("id"),
        choice_definition_options: d.fetch("options").map { |x| Option.from_dynamic!(x) },
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"      => id,
        "options" => choice_definition_options.map { |x| x.to_dynamic },
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class DefinitionKeyNameMap < Dry::Struct

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Choices < Dry::Struct
    attribute :race,                    Types.Array(ChoicesBackground)
    attribute :choices_class,           Types.Array(ChoicesBackground)
    attribute :background,              Types.Array(ChoicesBackground)
    attribute :item,                    Types::Nil
    attribute :feat,                    Types.Array(ChoicesBackground)
    attribute :choice_definitions,      Types.Array(ChoiceDefinition)
    attribute :definition_key_name_map, DefinitionKeyNameMap

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        race:                    d.fetch("race").map { |x| ChoicesBackground.from_dynamic!(x) },
        choices_class:           d.fetch("class").map { |x| ChoicesBackground.from_dynamic!(x) },
        background:              d.fetch("background").map { |x| ChoicesBackground.from_dynamic!(x) },
        item:                    d.fetch("item"),
        feat:                    d.fetch("feat").map { |x| ChoicesBackground.from_dynamic!(x) },
        choice_definitions:      d.fetch("choiceDefinitions").map { |x| ChoiceDefinition.from_dynamic!(x) },
        definition_key_name_map: DefinitionKeyNameMap.from_dynamic!(d.fetch("definitionKeyNameMap")),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "race"                 => race.map { |x| x.to_dynamic },
        "class"                => choices_class.map { |x| x.to_dynamic },
        "background"           => background.map { |x| x.to_dynamic },
        "item"                 => item,
        "feat"                 => feat.map { |x| x.to_dynamic },
        "choiceDefinitions"    => choice_definitions.map { |x| x.to_dynamic },
        "definitionKeyNameMap" => definition_key_name_map.to_dynamic,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ClassSpell < Dry::Struct
    attribute :entity_type_id,     Types::Integer
    attribute :character_class_id, Types::Integer
    attribute :spells,             Types.Array(Types::Any)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        entity_type_id:     d.fetch("entityTypeId"),
        character_class_id: d.fetch("characterClassId"),
        spells:             d.fetch("spells"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "entityTypeId"     => entity_type_id,
        "characterClassId" => character_class_id,
        "spells"           => spells,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  module EntityType
    ClassFeature = "class-feature"
  end

  class LevelScale < Dry::Struct
    attribute :id,          Types::Integer
    attribute :level,       Types::Integer
    attribute :description, Types::String
    attribute :dice,        Die.optional
    attribute :fixed_value, Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:          d.fetch("id"),
        level:       d.fetch("level"),
        description: d.fetch("description"),
        dice:        d.fetch("dice") ? Die.from_dynamic!(d.fetch("dice")) : nil,
        fixed_value: d.fetch("fixedValue"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"          => id,
        "level"       => level,
        "description" => description,
        "dice"        => dice&.to_dynamic,
        "fixedValue"  => fixed_value,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class LimitedUseElement < Dry::Struct
    attribute :level, Types::Nil
    attribute :uses,  Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        level: d.fetch("level"),
        uses:  d.fetch("uses"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "level" => level,
        "uses"  => uses,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ClassFeatureDefinition < Dry::Struct
    attribute :id,                               Types::Integer
    attribute :definition_key,                   Types::String
    attribute :entity_type_id,                   Types::Integer
    attribute :display_order,                    Types::Integer
    attribute :definition_name,                  Types::String
    attribute :description,                      Types::String
    attribute :snippet,                          Types::String.optional
    attribute :activation,                       Types::Nil
    attribute :multi_class_description,          Types::String
    attribute :required_level,                   Types::Integer
    attribute :is_sub_class_feature,             Types::Bool
    attribute :limited_use,                      Types.Array(LimitedUseElement)
    attribute :hide_in_builder,                  Types::Bool
    attribute :hide_in_sheet,                    Types::Bool
    attribute :source_id,                        Types::Integer
    attribute :source_page_number,               Types::Integer.optional
    attribute :creature_rules,                   Types.Array(Types::Any)
    attribute :level_scales,                     Types.Array(LevelScale)
    attribute :infusion_rules,                   Types.Array(Types::Any)
    attribute :spell_list_ids,                   Types.Array(Types::Any)
    attribute :class_id,                         Types::Integer
    attribute :feature_type,                     Types::Integer
    attribute :sources,                          Types.Array(Source)
    attribute :affected_feature_definition_keys, Types.Array(Types::Any)
    attribute :entity_type,                      Types::EntityType
    attribute :entity_id,                        Types::String

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                               d.fetch("id"),
        definition_key:                   d.fetch("definitionKey"),
        entity_type_id:                   d.fetch("entityTypeId"),
        display_order:                    d.fetch("displayOrder"),
        definition_name:                  d.fetch("name"),
        description:                      d.fetch("description"),
        snippet:                          d.fetch("snippet"),
        activation:                       d.fetch("activation"),
        multi_class_description:          d.fetch("multiClassDescription"),
        required_level:                   d.fetch("requiredLevel"),
        is_sub_class_feature:             d.fetch("isSubClassFeature"),
        limited_use:                      d.fetch("limitedUse").map { |x| LimitedUseElement.from_dynamic!(x) },
        hide_in_builder:                  d.fetch("hideInBuilder"),
        hide_in_sheet:                    d.fetch("hideInSheet"),
        source_id:                        d.fetch("sourceId"),
        source_page_number:               d.fetch("sourcePageNumber"),
        creature_rules:                   d.fetch("creatureRules"),
        level_scales:                     d.fetch("levelScales").map { |x| LevelScale.from_dynamic!(x) },
        infusion_rules:                   d.fetch("infusionRules"),
        spell_list_ids:                   d.fetch("spellListIds"),
        class_id:                         d.fetch("classId"),
        feature_type:                     d.fetch("featureType"),
        sources:                          d.fetch("sources").map { |x| Source.from_dynamic!(x) },
        affected_feature_definition_keys: d.fetch("affectedFeatureDefinitionKeys"),
        entity_type:                      d.fetch("entityType"),
        entity_id:                        d.fetch("entityID"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                            => id,
        "definitionKey"                 => definition_key,
        "entityTypeId"                  => entity_type_id,
        "displayOrder"                  => display_order,
        "name"                          => definition_name,
        "description"                   => description,
        "snippet"                       => snippet,
        "activation"                    => activation,
        "multiClassDescription"         => multi_class_description,
        "requiredLevel"                 => required_level,
        "isSubClassFeature"             => is_sub_class_feature,
        "limitedUse"                    => limited_use.map { |x| x.to_dynamic },
        "hideInBuilder"                 => hide_in_builder,
        "hideInSheet"                   => hide_in_sheet,
        "sourceId"                      => source_id,
        "sourcePageNumber"              => source_page_number,
        "creatureRules"                 => creature_rules,
        "levelScales"                   => level_scales.map { |x| x.to_dynamic },
        "infusionRules"                 => infusion_rules,
        "spellListIds"                  => spell_list_ids,
        "classId"                       => class_id,
        "featureType"                   => feature_type,
        "sources"                       => sources.map { |x| x.to_dynamic },
        "affectedFeatureDefinitionKeys" => affected_feature_definition_keys,
        "entityType"                    => entity_type,
        "entityID"                      => entity_id,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class ClassClassFeature < Dry::Struct
    attribute :definition,  ClassFeatureDefinition
    attribute :level_scale, LevelScale.optional

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        definition:  ClassFeatureDefinition.from_dynamic!(d.fetch("definition")),
        level_scale: d.fetch("levelScale") ? LevelScale.from_dynamic!(d.fetch("levelScale")) : nil,
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "definition" => definition.to_dynamic,
        "levelScale" => level_scale&.to_dynamic,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class DefinitionClassFeature < Dry::Struct
    attribute :id,                 Types::Integer
    attribute :class_feature_name, Types::String
    attribute :prerequisite,       Types::Nil
    attribute :description,        Types::String
    attribute :required_level,     Types::Integer
    attribute :display_order,      Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                 d.fetch("id"),
        class_feature_name: d.fetch("name"),
        prerequisite:       d.fetch("prerequisite"),
        description:        d.fetch("description"),
        required_level:     d.fetch("requiredLevel"),
        display_order:      d.fetch("displayOrder"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"            => id,
        "name"          => class_feature_name,
        "prerequisite"  => prerequisite,
        "description"   => description,
        "requiredLevel" => required_level,
        "displayOrder"  => display_order,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class PrerequisiteMapping < Dry::Struct
    attribute :id,                        Types::Integer
    attribute :entity_id,                 Types::Integer
    attribute :entity_type_id,            Types::Integer
    attribute :prerequisite_mapping_type, Types::String
    attribute :sub_type,                  Types::String
    attribute :value,                     Types::Integer.optional
    attribute :friendly_type_name,        Types::String
    attribute :friendly_sub_type_name,    Types::String

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                        d.fetch("id"),
        entity_id:                 d.fetch("entityId"),
        entity_type_id:            d.fetch("entityTypeId"),
        prerequisite_mapping_type: d.fetch("type"),
        sub_type:                  d.fetch("subType"),
        value:                     d.fetch("value"),
        friendly_type_name:        d.fetch("friendlyTypeName"),
        friendly_sub_type_name:    d.fetch("friendlySubTypeName"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                  => id,
        "entityId"            => entity_id,
        "entityTypeId"        => entity_type_id,
        "type"                => prerequisite_mapping_type,
        "subType"             => sub_type,
        "value"               => value,
        "friendlyTypeName"    => friendly_type_name,
        "friendlySubTypeName" => friendly_sub_type_name,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Prerequisite < Dry::Struct
    attribute :description,           Types::String
    attribute :prerequisite_mappings, Types.Array(PrerequisiteMapping)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        description:           d.fetch("description"),
        prerequisite_mappings: d.fetch("prerequisiteMappings").map { |x| PrerequisiteMapping.from_dynamic!(x) },
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "description"          => description,
        "prerequisiteMappings" => prerequisite_mappings.map { |x| x.to_dynamic },
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class SpellRules < Dry::Struct
    attribute :multi_class_spell_slot_divisor,  Types::Integer
    attribute :is_ritual_spell_caster,          Types::Bool
    attribute :level_cantrips_known_maxes,      Types.Array(Types::Integer)
    attribute :level_spell_known_maxes,         Types.Array(Types::Integer)
    attribute :level_spell_slots,               Types.Array(Types.Array(Types::Integer))
    attribute :multi_class_spell_slot_rounding, Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        multi_class_spell_slot_divisor:  d.fetch("multiClassSpellSlotDivisor"),
        is_ritual_spell_caster:          d.fetch("isRitualSpellCaster"),
        level_cantrips_known_maxes:      d.fetch("levelCantripsKnownMaxes"),
        level_spell_known_maxes:         d.fetch("levelSpellKnownMaxes"),
        level_spell_slots:               d.fetch("levelSpellSlots"),
        multi_class_spell_slot_rounding: d.fetch("multiClassSpellSlotRounding"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "multiClassSpellSlotDivisor"  => multi_class_spell_slot_divisor,
        "isRitualSpellCaster"         => is_ritual_spell_caster,
        "levelCantripsKnownMaxes"     => level_cantrips_known_maxes,
        "levelSpellKnownMaxes"        => level_spell_known_maxes,
        "levelSpellSlots"             => level_spell_slots,
        "multiClassSpellSlotRounding" => multi_class_spell_slot_rounding,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class SubclassDefinitionClass < Dry::Struct
    attribute :id,                       Types::Integer
    attribute :definition_key,           Types::String
    attribute :definition_name,          Types::String
    attribute :description,              Types::String
    attribute :equipment_description,    Types::String.optional
    attribute :parent_class_id,          Types::Integer.optional
    attribute :avatar_url,               Types::String.optional
    attribute :large_avatar_url,         Types::String.optional
    attribute :portrait_avatar_url,      Types::String.optional
    attribute :more_details_url,         Types::String
    attribute :spell_casting_ability_id, Types::Nil
    attribute :sources,                  Types.Array(Source)
    attribute :class_features,           Types.Array(DefinitionClassFeature)
    attribute :hit_dice,                 Types::Integer
    attribute :wealth_dice,              Die.optional
    attribute :can_cast_spells,          Types::Bool
    attribute :knows_all_spells,         Types::Nil
    attribute :spell_prepare_type,       Types::Nil
    attribute :spell_container_name,     Types::Nil
    attribute :source_page_number,       Types::Integer.optional
    attribute :subclass_definition,      Types::Nil
    attribute :is_homebrew,              Types::Bool
    attribute :primary_abilities,        Types.Array(Types::Integer).optional
    attribute :spell_rules,              SpellRules.optional
    attribute :prerequisites,            Types.Array(Prerequisite).optional

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                       d.fetch("id"),
        definition_key:           d.fetch("definitionKey"),
        definition_name:          d.fetch("name"),
        description:              d.fetch("description"),
        equipment_description:    d.fetch("equipmentDescription"),
        parent_class_id:          d.fetch("parentClassId"),
        avatar_url:               d.fetch("avatarUrl"),
        large_avatar_url:         d.fetch("largeAvatarUrl"),
        portrait_avatar_url:      d.fetch("portraitAvatarUrl"),
        more_details_url:         d.fetch("moreDetailsUrl"),
        spell_casting_ability_id: d.fetch("spellCastingAbilityId"),
        sources:                  d.fetch("sources").map { |x| Source.from_dynamic!(x) },
        class_features:           d.fetch("classFeatures").map { |x| DefinitionClassFeature.from_dynamic!(x) },
        hit_dice:                 d.fetch("hitDice"),
        wealth_dice:              d.fetch("wealthDice") ? Die.from_dynamic!(d.fetch("wealthDice")) : nil,
        can_cast_spells:          d.fetch("canCastSpells"),
        knows_all_spells:         d.fetch("knowsAllSpells"),
        spell_prepare_type:       d.fetch("spellPrepareType"),
        spell_container_name:     d.fetch("spellContainerName"),
        source_page_number:       d.fetch("sourcePageNumber"),
        subclass_definition:      d.fetch("subclassDefinition"),
        is_homebrew:              d.fetch("isHomebrew"),
        primary_abilities:        d.fetch("primaryAbilities"),
        spell_rules:              d.fetch("spellRules") ? SpellRules.from_dynamic!(d.fetch("spellRules")) : nil,
        prerequisites:            d.fetch("prerequisites")&.map { |x| Prerequisite.from_dynamic!(x) },
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                    => id,
        "definitionKey"         => definition_key,
        "name"                  => definition_name,
        "description"           => description,
        "equipmentDescription"  => equipment_description,
        "parentClassId"         => parent_class_id,
        "avatarUrl"             => avatar_url,
        "largeAvatarUrl"        => large_avatar_url,
        "portraitAvatarUrl"     => portrait_avatar_url,
        "moreDetailsUrl"        => more_details_url,
        "spellCastingAbilityId" => spell_casting_ability_id,
        "sources"               => sources.map { |x| x.to_dynamic },
        "classFeatures"         => class_features.map { |x| x.to_dynamic },
        "hitDice"               => hit_dice,
        "wealthDice"            => wealth_dice&.to_dynamic,
        "canCastSpells"         => can_cast_spells,
        "knowsAllSpells"        => knows_all_spells,
        "spellPrepareType"      => spell_prepare_type,
        "spellContainerName"    => spell_container_name,
        "sourcePageNumber"      => source_page_number,
        "subclassDefinition"    => subclass_definition,
        "isHomebrew"            => is_homebrew,
        "primaryAbilities"      => primary_abilities,
        "spellRules"            => spell_rules&.to_dynamic,
        "prerequisites"         => prerequisites&.map { |x| x.to_dynamic },
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class CharacterClass < Dry::Struct
    attribute :id,                     Types::Integer
    attribute :entity_type_id,         Types::Integer
    attribute :level,                  Types::Integer
    attribute :is_starting_class,      Types::Bool
    attribute :hit_dice_used,          Types::Integer
    attribute :definition_id,          Types::Integer
    attribute :subclass_definition_id, Types::Nil
    attribute :definition,             SubclassDefinitionClass
    attribute :subclass_definition,    SubclassDefinitionClass
    attribute :class_features,         Types.Array(ClassClassFeature)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                     d.fetch("id"),
        entity_type_id:         d.fetch("entityTypeId"),
        level:                  d.fetch("level"),
        is_starting_class:      d.fetch("isStartingClass"),
        hit_dice_used:          d.fetch("hitDiceUsed"),
        definition_id:          d.fetch("definitionId"),
        subclass_definition_id: d.fetch("subclassDefinitionId"),
        definition:             SubclassDefinitionClass.from_dynamic!(d.fetch("definition")),
        subclass_definition:    SubclassDefinitionClass.from_dynamic!(d.fetch("subclassDefinition")),
        class_features:         d.fetch("classFeatures").map { |x| ClassClassFeature.from_dynamic!(x) },
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                   => id,
        "entityTypeId"         => entity_type_id,
        "level"                => level,
        "isStartingClass"      => is_starting_class,
        "hitDiceUsed"          => hit_dice_used,
        "definitionId"         => definition_id,
        "subclassDefinitionId" => subclass_definition_id,
        "definition"           => definition.to_dynamic,
        "subclassDefinition"   => subclass_definition.to_dynamic,
        "classFeatures"        => class_features.map { |x| x.to_dynamic },
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Configuration < Dry::Struct
    attribute :starting_equipment_type, Types::Integer
    attribute :ability_score_type,      Types::Integer
    attribute :show_help_text,          Types::Bool

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        starting_equipment_type: d.fetch("startingEquipmentType"),
        ability_score_type:      d.fetch("abilityScoreType"),
        show_help_text:          d.fetch("showHelpText"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "startingEquipmentType" => starting_equipment_type,
        "abilityScoreType"      => ability_score_type,
        "showHelpText"          => show_help_text,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Currencies < Dry::Struct
    attribute :cp, Types::Integer
    attribute :sp, Types::Integer
    attribute :gp, Types::Integer
    attribute :ep, Types::Integer
    attribute :pp, Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        cp: d.fetch("cp"),
        sp: d.fetch("sp"),
        gp: d.fetch("gp"),
        ep: d.fetch("ep"),
        pp: d.fetch("pp"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "cp" => cp,
        "sp" => sp,
        "gp" => gp,
        "ep" => ep,
        "pp" => pp,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class DeathSaves < Dry::Struct
    attribute :fail_count,    Types::Nil
    attribute :success_count, Types::Nil
    attribute :is_stabilized, Types::Bool

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        fail_count:    d.fetch("failCount"),
        success_count: d.fetch("successCount"),
        is_stabilized: d.fetch("isStabilized"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "failCount"    => fail_count,
        "successCount" => success_count,
        "isStabilized" => is_stabilized,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class DefaultBackdrop < Dry::Struct
    attribute :backdrop_avatar_url,           Types::String
    attribute :small_backdrop_avatar_url,     Types::String
    attribute :large_backdrop_avatar_url,     Types::String
    attribute :thumbnail_backdrop_avatar_url, Types::String

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        backdrop_avatar_url:           d.fetch("backdropAvatarUrl"),
        small_backdrop_avatar_url:     d.fetch("smallBackdropAvatarUrl"),
        large_backdrop_avatar_url:     d.fetch("largeBackdropAvatarUrl"),
        thumbnail_backdrop_avatar_url: d.fetch("thumbnailBackdropAvatarUrl"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "backdropAvatarUrl"          => backdrop_avatar_url,
        "smallBackdropAvatarUrl"     => small_backdrop_avatar_url,
        "largeBackdropAvatarUrl"     => large_backdrop_avatar_url,
        "thumbnailBackdropAvatarUrl" => thumbnail_backdrop_avatar_url,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Decorations < Dry::Struct
    attribute :avatar_url,                               Types::Nil
    attribute :frame_avatar_url,                         Types::Nil
    attribute :backdrop_avatar_url,                      Types::Nil
    attribute :small_backdrop_avatar_url,                Types::Nil
    attribute :large_backdrop_avatar_url,                Types::Nil
    attribute :thumbnail_backdrop_avatar_url,            Types::Nil
    attribute :default_backdrop,                         DefaultBackdrop
    attribute :avatar_id,                                Types::Nil
    attribute :portrait_decoration_key,                  Types::Nil
    attribute :frame_avatar_decoration_key,              Types::Nil
    attribute :frame_avatar_id,                          Types::Nil
    attribute :backdrop_avatar_decoration_key,           Types::Nil
    attribute :backdrop_avatar_id,                       Types::Nil
    attribute :small_backdrop_avatar_decoration_key,     Types::String
    attribute :small_backdrop_avatar_id,                 Types::Nil
    attribute :large_backdrop_avatar_decoration_key,     Types::String
    attribute :large_backdrop_avatar_id,                 Types::Nil
    attribute :thumbnail_backdrop_avatar_decoration_key, Types::String
    attribute :thumbnail_backdrop_avatar_id,             Types::Nil
    attribute :theme_color,                              Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        avatar_url:                               d.fetch("avatarUrl"),
        frame_avatar_url:                         d.fetch("frameAvatarUrl"),
        backdrop_avatar_url:                      d.fetch("backdropAvatarUrl"),
        small_backdrop_avatar_url:                d.fetch("smallBackdropAvatarUrl"),
        large_backdrop_avatar_url:                d.fetch("largeBackdropAvatarUrl"),
        thumbnail_backdrop_avatar_url:            d.fetch("thumbnailBackdropAvatarUrl"),
        default_backdrop:                         DefaultBackdrop.from_dynamic!(d.fetch("defaultBackdrop")),
        avatar_id:                                d.fetch("avatarId"),
        portrait_decoration_key:                  d.fetch("portraitDecorationKey"),
        frame_avatar_decoration_key:              d.fetch("frameAvatarDecorationKey"),
        frame_avatar_id:                          d.fetch("frameAvatarId"),
        backdrop_avatar_decoration_key:           d.fetch("backdropAvatarDecorationKey"),
        backdrop_avatar_id:                       d.fetch("backdropAvatarId"),
        small_backdrop_avatar_decoration_key:     d.fetch("smallBackdropAvatarDecorationKey"),
        small_backdrop_avatar_id:                 d.fetch("smallBackdropAvatarId"),
        large_backdrop_avatar_decoration_key:     d.fetch("largeBackdropAvatarDecorationKey"),
        large_backdrop_avatar_id:                 d.fetch("largeBackdropAvatarId"),
        thumbnail_backdrop_avatar_decoration_key: d.fetch("thumbnailBackdropAvatarDecorationKey"),
        thumbnail_backdrop_avatar_id:             d.fetch("thumbnailBackdropAvatarId"),
        theme_color:                              d.fetch("themeColor"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "avatarUrl"                            => avatar_url,
        "frameAvatarUrl"                       => frame_avatar_url,
        "backdropAvatarUrl"                    => backdrop_avatar_url,
        "smallBackdropAvatarUrl"               => small_backdrop_avatar_url,
        "largeBackdropAvatarUrl"               => large_backdrop_avatar_url,
        "thumbnailBackdropAvatarUrl"           => thumbnail_backdrop_avatar_url,
        "defaultBackdrop"                      => default_backdrop.to_dynamic,
        "avatarId"                             => avatar_id,
        "portraitDecorationKey"                => portrait_decoration_key,
        "frameAvatarDecorationKey"             => frame_avatar_decoration_key,
        "frameAvatarId"                        => frame_avatar_id,
        "backdropAvatarDecorationKey"          => backdrop_avatar_decoration_key,
        "backdropAvatarId"                     => backdrop_avatar_id,
        "smallBackdropAvatarDecorationKey"     => small_backdrop_avatar_decoration_key,
        "smallBackdropAvatarId"                => small_backdrop_avatar_id,
        "largeBackdropAvatarDecorationKey"     => large_backdrop_avatar_decoration_key,
        "largeBackdropAvatarId"                => large_backdrop_avatar_id,
        "thumbnailBackdropAvatarDecorationKey" => thumbnail_backdrop_avatar_decoration_key,
        "thumbnailBackdropAvatarId"            => thumbnail_backdrop_avatar_id,
        "themeColor"                           => theme_color,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class FeatDefinition < Dry::Struct
    attribute :id,                 Types::Integer
    attribute :entity_type_id,     Types::Integer
    attribute :definition_key,     Types::String
    attribute :definition_name,    Types::String
    attribute :description,        Types::String
    attribute :snippet,            Types::String
    attribute :activation,         Activation
    attribute :source_id,          Types::Nil
    attribute :source_page_number, Types::Nil
    attribute :creature_rules,     Types.Array(Types::Any)
    attribute :prerequisites,      Types.Array(Prerequisite)
    attribute :is_homebrew,        Types::Bool
    attribute :sources,            Types.Array(Source)
    attribute :spell_list_ids,     Types.Array(Types::Any)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                 d.fetch("id"),
        entity_type_id:     d.fetch("entityTypeId"),
        definition_key:     d.fetch("definitionKey"),
        definition_name:    d.fetch("name"),
        description:        d.fetch("description"),
        snippet:            d.fetch("snippet"),
        activation:         Activation.from_dynamic!(d.fetch("activation")),
        source_id:          d.fetch("sourceId"),
        source_page_number: d.fetch("sourcePageNumber"),
        creature_rules:     d.fetch("creatureRules"),
        prerequisites:      d.fetch("prerequisites").map { |x| Prerequisite.from_dynamic!(x) },
        is_homebrew:        d.fetch("isHomebrew"),
        sources:            d.fetch("sources").map { |x| Source.from_dynamic!(x) },
        spell_list_ids:     d.fetch("spellListIds"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"               => id,
        "entityTypeId"     => entity_type_id,
        "definitionKey"    => definition_key,
        "name"             => definition_name,
        "description"      => description,
        "snippet"          => snippet,
        "activation"       => activation.to_dynamic,
        "sourceId"         => source_id,
        "sourcePageNumber" => source_page_number,
        "creatureRules"    => creature_rules,
        "prerequisites"    => prerequisites.map { |x| x.to_dynamic },
        "isHomebrew"       => is_homebrew,
        "sources"          => sources.map { |x| x.to_dynamic },
        "spellListIds"     => spell_list_ids,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Feat < Dry::Struct
    attribute :component_type_id, Types::Integer
    attribute :component_id,      Types::Integer
    attribute :definition,        FeatDefinition
    attribute :definition_id,     Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        component_type_id: d.fetch("componentTypeId"),
        component_id:      d.fetch("componentId"),
        definition:        FeatDefinition.from_dynamic!(d.fetch("definition")),
        definition_id:     d.fetch("definitionId"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "componentTypeId" => component_type_id,
        "componentId"     => component_id,
        "definition"      => definition.to_dynamic,
        "definitionId"    => definition_id,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  module ContainerDefinitionKey
    The158111142353552888 = "1581111423:53552888"
  end

  module FilterType
    Armor     = "Armor"
    OtherGear = "Other Gear"
    Potion    = "Potion"
    Weapon    = "Weapon"
  end

  class Property < Dry::Struct
    attribute :id,            Types::Integer
    attribute :property_name, Types::String
    attribute :description,   Types::String
    attribute :notes,         Types::String.optional

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:            d.fetch("id"),
        property_name: d.fetch("name"),
        description:   d.fetch("description"),
        notes:         d.fetch("notes"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"          => id,
        "name"        => property_name,
        "description" => description,
        "notes"       => notes,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  module Rarity
    Common   = "Common"
    Rare     = "Rare"
    Uncommon = "Uncommon"
  end

  class InventoryDefinition < Dry::Struct
    attribute :id,                        Types::Integer
    attribute :base_type_id,              Types::Integer
    attribute :entity_type_id,            Types::Integer
    attribute :definition_key,            Types::String
    attribute :can_equip,                 Types::Bool
    attribute :magic,                     Types::Bool
    attribute :definition_name,           Types::String
    attribute :snippet,                   Types::String.optional
    attribute :weight,                    Types::Double
    attribute :weight_multiplier,         Types::Integer
    attribute :capacity,                  Types::String.optional
    attribute :capacity_weight,           Types::Integer
    attribute :definition_type,           Types::String
    attribute :description,               Types::String
    attribute :can_attune,                Types::Bool
    attribute :attunement_description,    Types::String.optional
    attribute :rarity,                    Types::Rarity
    attribute :is_homebrew,               Types::Bool
    attribute :version,                   Types::Nil
    attribute :source_id,                 Types::Nil
    attribute :source_page_number,        Types::Nil
    attribute :stackable,                 Types::Bool
    attribute :bundle_size,               Types::Integer
    attribute :avatar_url,                Types::Nil
    attribute :large_avatar_url,          Types::Nil
    attribute :filter_type,               Types::FilterType
    attribute :cost,                      Types::Double.optional
    attribute :is_pack,                   Types::Bool
    attribute :tags,                      Types.Array(Types::String)
    attribute :granted_modifiers,         Types.Array(ItemElement)
    attribute :sub_type,                  Types::String.optional
    attribute :is_consumable,             Types::Bool
    attribute :weapon_behaviors,          Types.Array(Types::Any)
    attribute :base_item_id,              Types::Integer.optional
    attribute :base_armor_name,           Types::String.optional
    attribute :strength_requirement,      Types::Integer.optional
    attribute :armor_class,               Types::Integer.optional
    attribute :stealth_check,             Types::Integer.optional
    attribute :damage,                    Die.optional
    attribute :damage_type,               Types::String.optional
    attribute :fixed_damage,              Types::Nil
    attribute :properties,                Types.Array(Property).optional
    attribute :attack_type,               Types::Integer.optional
    attribute :category_id,               Types::Integer.optional
    attribute :range,                     Types::Integer.optional
    attribute :long_range,                Types::Integer.optional
    attribute :is_monk_weapon,            Types::Bool
    attribute :level_infusion_granted,    Types::Nil
    attribute :sources,                   Types.Array(Source)
    attribute :armor_type_id,             Types::Integer.optional
    attribute :gear_type_id,              Types::Integer.optional
    attribute :grouped_id,                Types::Integer.optional
    attribute :can_be_added_to_inventory, Types::Bool
    attribute :is_container,              Types::Bool
    attribute :is_custom_item,            Types::Bool

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                        d.fetch("id"),
        base_type_id:              d.fetch("baseTypeId"),
        entity_type_id:            d.fetch("entityTypeId"),
        definition_key:            d.fetch("definitionKey"),
        can_equip:                 d.fetch("canEquip"),
        magic:                     d.fetch("magic"),
        definition_name:           d.fetch("name"),
        snippet:                   d.fetch("snippet"),
        weight:                    d.fetch("weight"),
        weight_multiplier:         d.fetch("weightMultiplier"),
        capacity:                  d.fetch("capacity"),
        capacity_weight:           d.fetch("capacityWeight"),
        definition_type:           d.fetch("type"),
        description:               d.fetch("description"),
        can_attune:                d.fetch("canAttune"),
        attunement_description:    d.fetch("attunementDescription"),
        rarity:                    d.fetch("rarity"),
        is_homebrew:               d.fetch("isHomebrew"),
        version:                   d.fetch("version"),
        source_id:                 d.fetch("sourceId"),
        source_page_number:        d.fetch("sourcePageNumber"),
        stackable:                 d.fetch("stackable"),
        bundle_size:               d.fetch("bundleSize"),
        avatar_url:                d.fetch("avatarUrl"),
        large_avatar_url:          d.fetch("largeAvatarUrl"),
        filter_type:               d.fetch("filterType"),
        cost:                      d.fetch("cost"),
        is_pack:                   d.fetch("isPack"),
        tags:                      d.fetch("tags"),
        granted_modifiers:         d.fetch("grantedModifiers").map { |x| ItemElement.from_dynamic!(x) },
        sub_type:                  d.fetch("subType"),
        is_consumable:             d.fetch("isConsumable"),
        weapon_behaviors:          d.fetch("weaponBehaviors"),
        base_item_id:              d.fetch("baseItemId"),
        base_armor_name:           d.fetch("baseArmorName"),
        strength_requirement:      d.fetch("strengthRequirement"),
        armor_class:               d.fetch("armorClass"),
        stealth_check:             d.fetch("stealthCheck"),
        damage:                    d.fetch("damage") ? Die.from_dynamic!(d.fetch("damage")) : nil,
        damage_type:               d.fetch("damageType"),
        fixed_damage:              d.fetch("fixedDamage"),
        properties:                d.fetch("properties")&.map { |x| Property.from_dynamic!(x) },
        attack_type:               d.fetch("attackType"),
        category_id:               d.fetch("categoryId"),
        range:                     d.fetch("range"),
        long_range:                d.fetch("longRange"),
        is_monk_weapon:            d.fetch("isMonkWeapon"),
        level_infusion_granted:    d.fetch("levelInfusionGranted"),
        sources:                   d.fetch("sources").map { |x| Source.from_dynamic!(x) },
        armor_type_id:             d.fetch("armorTypeId"),
        gear_type_id:              d.fetch("gearTypeId"),
        grouped_id:                d.fetch("groupedId"),
        can_be_added_to_inventory: d.fetch("canBeAddedToInventory"),
        is_container:              d.fetch("isContainer"),
        is_custom_item:            d.fetch("isCustomItem"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                    => id,
        "baseTypeId"            => base_type_id,
        "entityTypeId"          => entity_type_id,
        "definitionKey"         => definition_key,
        "canEquip"              => can_equip,
        "magic"                 => magic,
        "name"                  => definition_name,
        "snippet"               => snippet,
        "weight"                => weight,
        "weightMultiplier"      => weight_multiplier,
        "capacity"              => capacity,
        "capacityWeight"        => capacity_weight,
        "type"                  => definition_type,
        "description"           => description,
        "canAttune"             => can_attune,
        "attunementDescription" => attunement_description,
        "rarity"                => rarity,
        "isHomebrew"            => is_homebrew,
        "version"               => version,
        "sourceId"              => source_id,
        "sourcePageNumber"      => source_page_number,
        "stackable"             => stackable,
        "bundleSize"            => bundle_size,
        "avatarUrl"             => avatar_url,
        "largeAvatarUrl"        => large_avatar_url,
        "filterType"            => filter_type,
        "cost"                  => cost,
        "isPack"                => is_pack,
        "tags"                  => tags,
        "grantedModifiers"      => granted_modifiers.map { |x| x.to_dynamic },
        "subType"               => sub_type,
        "isConsumable"          => is_consumable,
        "weaponBehaviors"       => weapon_behaviors,
        "baseItemId"            => base_item_id,
        "baseArmorName"         => base_armor_name,
        "strengthRequirement"   => strength_requirement,
        "armorClass"            => armor_class,
        "stealthCheck"          => stealth_check,
        "damage"                => damage&.to_dynamic,
        "damageType"            => damage_type,
        "fixedDamage"           => fixed_damage,
        "properties"            => properties&.map { |x| x.to_dynamic },
        "attackType"            => attack_type,
        "categoryId"            => category_id,
        "range"                 => range,
        "longRange"             => long_range,
        "isMonkWeapon"          => is_monk_weapon,
        "levelInfusionGranted"  => level_infusion_granted,
        "sources"               => sources.map { |x| x.to_dynamic },
        "armorTypeId"           => armor_type_id,
        "gearTypeId"            => gear_type_id,
        "groupedId"             => grouped_id,
        "canBeAddedToInventory" => can_be_added_to_inventory,
        "isContainer"           => is_container,
        "isCustomItem"          => is_custom_item,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class InventoryLimitedUse < Dry::Struct
    attribute :max_uses,               Types::Integer
    attribute :number_used,            Types::Integer
    attribute :reset_type,             Types::String
    attribute :reset_type_description, Types::String

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        max_uses:               d.fetch("maxUses"),
        number_used:            d.fetch("numberUsed"),
        reset_type:             d.fetch("resetType"),
        reset_type_description: d.fetch("resetTypeDescription"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "maxUses"              => max_uses,
        "numberUsed"           => number_used,
        "resetType"            => reset_type,
        "resetTypeDescription" => reset_type_description,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Inventory < Dry::Struct
    attribute :id,                       Types::Integer
    attribute :entity_type_id,           Types::Integer
    attribute :definition,               InventoryDefinition
    attribute :definition_id,            Types::Integer
    attribute :definition_type_id,       Types::Integer
    attribute :display_as_attack,        Types::Nil
    attribute :quantity,                 Types::Integer
    attribute :is_attuned,               Types::Bool
    attribute :equipped,                 Types::Bool
    attribute :equipped_entity_type_id,  Types::Integer.optional
    attribute :equipped_entity_id,       Types::Integer.optional
    attribute :charges_used,             Types::Integer
    attribute :limited_use,              InventoryLimitedUse.optional
    attribute :container_entity_id,      Types::Integer
    attribute :container_entity_type_id, Types::Integer
    attribute :container_definition_key, Types::ContainerDefinitionKey
    attribute :currency,                 Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                       d.fetch("id"),
        entity_type_id:           d.fetch("entityTypeId"),
        definition:               InventoryDefinition.from_dynamic!(d.fetch("definition")),
        definition_id:            d.fetch("definitionId"),
        definition_type_id:       d.fetch("definitionTypeId"),
        display_as_attack:        d.fetch("displayAsAttack"),
        quantity:                 d.fetch("quantity"),
        is_attuned:               d.fetch("isAttuned"),
        equipped:                 d.fetch("equipped"),
        equipped_entity_type_id:  d.fetch("equippedEntityTypeId"),
        equipped_entity_id:       d.fetch("equippedEntityId"),
        charges_used:             d.fetch("chargesUsed"),
        limited_use:              d.fetch("limitedUse") ? InventoryLimitedUse.from_dynamic!(d.fetch("limitedUse")) : nil,
        container_entity_id:      d.fetch("containerEntityId"),
        container_entity_type_id: d.fetch("containerEntityTypeId"),
        container_definition_key: d.fetch("containerDefinitionKey"),
        currency:                 d.fetch("currency"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                     => id,
        "entityTypeId"           => entity_type_id,
        "definition"             => definition.to_dynamic,
        "definitionId"           => definition_id,
        "definitionTypeId"       => definition_type_id,
        "displayAsAttack"        => display_as_attack,
        "quantity"               => quantity,
        "isAttuned"              => is_attuned,
        "equipped"               => equipped,
        "equippedEntityTypeId"   => equipped_entity_type_id,
        "equippedEntityId"       => equipped_entity_id,
        "chargesUsed"            => charges_used,
        "limitedUse"             => limited_use&.to_dynamic,
        "containerEntityId"      => container_entity_id,
        "containerEntityTypeId"  => container_entity_type_id,
        "containerDefinitionKey" => container_definition_key,
        "currency"               => currency,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Modifiers < Dry::Struct
    attribute :race,            Types.Array(ItemElement)
    attribute :modifiers_class, Types.Array(ItemElement)
    attribute :background,      Types.Array(ItemElement)
    attribute :item,            Types.Array(ItemElement)
    attribute :feat,            Types.Array(ItemElement)
    attribute :condition,       Types.Array(Types::Any)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        race:            d.fetch("race").map { |x| ItemElement.from_dynamic!(x) },
        modifiers_class: d.fetch("class").map { |x| ItemElement.from_dynamic!(x) },
        background:      d.fetch("background").map { |x| ItemElement.from_dynamic!(x) },
        item:            d.fetch("item").map { |x| ItemElement.from_dynamic!(x) },
        feat:            d.fetch("feat").map { |x| ItemElement.from_dynamic!(x) },
        condition:       d.fetch("condition"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "race"       => race.map { |x| x.to_dynamic },
        "class"      => modifiers_class.map { |x| x.to_dynamic },
        "background" => background.map { |x| x.to_dynamic },
        "item"       => item.map { |x| x.to_dynamic },
        "feat"       => feat.map { |x| x.to_dynamic },
        "condition"  => condition,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Notes < Dry::Struct
    attribute :allies,               Types::Nil
    attribute :personal_possessions, Types::String
    attribute :other_holdings,       Types::Nil
    attribute :organizations,        Types::Nil
    attribute :enemies,              Types::Nil
    attribute :backstory,            Types::Nil
    attribute :other_notes,          Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        allies:               d.fetch("allies"),
        personal_possessions: d.fetch("personalPossessions"),
        other_holdings:       d.fetch("otherHoldings"),
        organizations:        d.fetch("organizations"),
        enemies:              d.fetch("enemies"),
        backstory:            d.fetch("backstory"),
        other_notes:          d.fetch("otherNotes"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "allies"              => allies,
        "personalPossessions" => personal_possessions,
        "otherHoldings"       => other_holdings,
        "organizations"       => organizations,
        "enemies"             => enemies,
        "backstory"           => backstory,
        "otherNotes"          => other_notes,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class PactMagic < Dry::Struct
    attribute :level,     Types::Integer
    attribute :used,      Types::Integer
    attribute :available, Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        level:     d.fetch("level"),
        used:      d.fetch("used"),
        available: d.fetch("available"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "level"     => level,
        "used"      => used,
        "available" => available,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Preferences < Dry::Struct
    attribute :use_homebrew_content,           Types::Bool
    attribute :progression_type,               Types::Integer
    attribute :encumbrance_type,               Types::Integer
    attribute :ignore_coin_weight,             Types::Bool
    attribute :hit_point_type,                 Types::Integer
    attribute :show_unarmed_strike,            Types::Bool
    attribute :show_scaled_spells,             Types::Bool
    attribute :primary_sense,                  Types::Integer
    attribute :primary_movement,               Types::Integer
    attribute :privacy_type,                   Types::Integer
    attribute :sharing_type,                   Types::Integer
    attribute :ability_score_display_type,     Types::Integer
    attribute :enforce_feat_rules,             Types::Bool
    attribute :enforce_multiclass_rules,       Types::Bool
    attribute :enable_optional_class_features, Types::Bool
    attribute :enable_optional_origins,        Types::Bool
    attribute :enable_dark_mode,               Types::Bool
    attribute :enable_container_currency,      Types::Bool

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        use_homebrew_content:           d.fetch("useHomebrewContent"),
        progression_type:               d.fetch("progressionType"),
        encumbrance_type:               d.fetch("encumbranceType"),
        ignore_coin_weight:             d.fetch("ignoreCoinWeight"),
        hit_point_type:                 d.fetch("hitPointType"),
        show_unarmed_strike:            d.fetch("showUnarmedStrike"),
        show_scaled_spells:             d.fetch("showScaledSpells"),
        primary_sense:                  d.fetch("primarySense"),
        primary_movement:               d.fetch("primaryMovement"),
        privacy_type:                   d.fetch("privacyType"),
        sharing_type:                   d.fetch("sharingType"),
        ability_score_display_type:     d.fetch("abilityScoreDisplayType"),
        enforce_feat_rules:             d.fetch("enforceFeatRules"),
        enforce_multiclass_rules:       d.fetch("enforceMulticlassRules"),
        enable_optional_class_features: d.fetch("enableOptionalClassFeatures"),
        enable_optional_origins:        d.fetch("enableOptionalOrigins"),
        enable_dark_mode:               d.fetch("enableDarkMode"),
        enable_container_currency:      d.fetch("enableContainerCurrency"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "useHomebrewContent"          => use_homebrew_content,
        "progressionType"             => progression_type,
        "encumbranceType"             => encumbrance_type,
        "ignoreCoinWeight"            => ignore_coin_weight,
        "hitPointType"                => hit_point_type,
        "showUnarmedStrike"           => show_unarmed_strike,
        "showScaledSpells"            => show_scaled_spells,
        "primarySense"                => primary_sense,
        "primaryMovement"             => primary_movement,
        "privacyType"                 => privacy_type,
        "sharingType"                 => sharing_type,
        "abilityScoreDisplayType"     => ability_score_display_type,
        "enforceFeatRules"            => enforce_feat_rules,
        "enforceMulticlassRules"      => enforce_multiclass_rules,
        "enableOptionalClassFeatures" => enable_optional_class_features,
        "enableOptionalOrigins"       => enable_optional_origins,
        "enableDarkMode"              => enable_dark_mode,
        "enableContainerCurrency"     => enable_container_currency,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class DisplayConfiguration < Dry::Struct
    attribute :racialtrait,  Types::Integer
    attribute :language,     Types::Integer
    attribute :abilityscore, Types::Integer
    attribute :classfeature, Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        racialtrait:  d.fetch("RACIALTRAIT"),
        language:     d.fetch("LANGUAGE"),
        abilityscore: d.fetch("ABILITYSCORE"),
        classfeature: d.fetch("CLASSFEATURE"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "RACIALTRAIT"  => racialtrait,
        "LANGUAGE"     => language,
        "ABILITYSCORE" => abilityscore,
        "CLASSFEATURE" => classfeature,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class RacialTraitDefinition < Dry::Struct
    attribute :id,                               Types::Integer
    attribute :definition_key,                   Types::String
    attribute :entity_type_id,                   Types::Integer
    attribute :display_order,                    Types::Integer
    attribute :definition_name,                  Types::String
    attribute :description,                      Types::String
    attribute :snippet,                          Types::String.optional
    attribute :hide_in_builder,                  Types::Bool
    attribute :hide_in_sheet,                    Types::Bool
    attribute :activation,                       Types::Nil
    attribute :source_id,                        Types::Integer
    attribute :source_page_number,               Types::Integer
    attribute :creature_rules,                   Types.Array(Types::Any)
    attribute :spell_list_ids,                   Types.Array(Types::Any)
    attribute :feature_type,                     Types::Integer
    attribute :sources,                          Types.Array(Source)
    attribute :affected_feature_definition_keys, Types.Array(Types::Any)
    attribute :is_called_out,                    Types::Bool
    attribute :entity_type,                      Types::String
    attribute :entity_id,                        Types::String
    attribute :entity_race_id,                   Types::Integer
    attribute :entity_race_type_id,              Types::Integer
    attribute :display_configuration,            DisplayConfiguration
    attribute :required_level,                   Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                               d.fetch("id"),
        definition_key:                   d.fetch("definitionKey"),
        entity_type_id:                   d.fetch("entityTypeId"),
        display_order:                    d.fetch("displayOrder"),
        definition_name:                  d.fetch("name"),
        description:                      d.fetch("description"),
        snippet:                          d.fetch("snippet"),
        hide_in_builder:                  d.fetch("hideInBuilder"),
        hide_in_sheet:                    d.fetch("hideInSheet"),
        activation:                       d.fetch("activation"),
        source_id:                        d.fetch("sourceId"),
        source_page_number:               d.fetch("sourcePageNumber"),
        creature_rules:                   d.fetch("creatureRules"),
        spell_list_ids:                   d.fetch("spellListIds"),
        feature_type:                     d.fetch("featureType"),
        sources:                          d.fetch("sources").map { |x| Source.from_dynamic!(x) },
        affected_feature_definition_keys: d.fetch("affectedFeatureDefinitionKeys"),
        is_called_out:                    d.fetch("isCalledOut"),
        entity_type:                      d.fetch("entityType"),
        entity_id:                        d.fetch("entityID"),
        entity_race_id:                   d.fetch("entityRaceId"),
        entity_race_type_id:              d.fetch("entityRaceTypeId"),
        display_configuration:            DisplayConfiguration.from_dynamic!(d.fetch("displayConfiguration")),
        required_level:                   d.fetch("requiredLevel"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                            => id,
        "definitionKey"                 => definition_key,
        "entityTypeId"                  => entity_type_id,
        "displayOrder"                  => display_order,
        "name"                          => definition_name,
        "description"                   => description,
        "snippet"                       => snippet,
        "hideInBuilder"                 => hide_in_builder,
        "hideInSheet"                   => hide_in_sheet,
        "activation"                    => activation,
        "sourceId"                      => source_id,
        "sourcePageNumber"              => source_page_number,
        "creatureRules"                 => creature_rules,
        "spellListIds"                  => spell_list_ids,
        "featureType"                   => feature_type,
        "sources"                       => sources.map { |x| x.to_dynamic },
        "affectedFeatureDefinitionKeys" => affected_feature_definition_keys,
        "isCalledOut"                   => is_called_out,
        "entityType"                    => entity_type,
        "entityID"                      => entity_id,
        "entityRaceId"                  => entity_race_id,
        "entityRaceTypeId"              => entity_race_type_id,
        "displayConfiguration"          => display_configuration.to_dynamic,
        "requiredLevel"                 => required_level,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class RacialTrait < Dry::Struct
    attribute :definition, RacialTraitDefinition

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        definition: RacialTraitDefinition.from_dynamic!(d.fetch("definition")),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "definition" => definition.to_dynamic,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Normal < Dry::Struct
    attribute :walk,   Types::Integer
    attribute :fly,    Types::Integer
    attribute :burrow, Types::Integer
    attribute :swim,   Types::Integer
    attribute :climb,  Types::Integer

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        walk:   d.fetch("walk"),
        fly:    d.fetch("fly"),
        burrow: d.fetch("burrow"),
        swim:   d.fetch("swim"),
        climb:  d.fetch("climb"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "walk"   => walk,
        "fly"    => fly,
        "burrow" => burrow,
        "swim"   => swim,
        "climb"  => climb,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class WeightSpeeds < Dry::Struct
    attribute :normal,             Normal
    attribute :encumbered,         Types::Nil
    attribute :heavily_encumbered, Types::Nil
    attribute :push_drag_lift,     Types::Nil
    attribute :override,           Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        normal:             Normal.from_dynamic!(d.fetch("normal")),
        encumbered:         d.fetch("encumbered"),
        heavily_encumbered: d.fetch("heavilyEncumbered"),
        push_drag_lift:     d.fetch("pushDragLift"),
        override:           d.fetch("override"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "normal"            => normal.to_dynamic,
        "encumbered"        => encumbered,
        "heavilyEncumbered" => heavily_encumbered,
        "pushDragLift"      => push_drag_lift,
        "override"          => override,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Race < Dry::Struct
    attribute :is_sub_race,         Types::Bool
    attribute :base_race_name,      Types::String
    attribute :entity_race_id,      Types::Integer
    attribute :entity_race_type_id, Types::Integer
    attribute :definition_key,      Types::String
    attribute :full_name,           Types::String
    attribute :base_race_id,        Types::Integer
    attribute :base_race_type_id,   Types::Integer
    attribute :description,         Types::String
    attribute :avatar_url,          Types::String
    attribute :large_avatar_url,    Types::String
    attribute :portrait_avatar_url, Types::String
    attribute :more_details_url,    Types::String
    attribute :is_homebrew,         Types::Bool
    attribute :is_legacy,           Types::Bool
    attribute :group_ids,           Types.Array(Types::Integer)
    attribute :race_type,           Types::Integer
    attribute :supports_subrace,    Types::Nil
    attribute :sub_race_short_name, Types::Nil
    attribute :base_name,           Types::String
    attribute :racial_traits,       Types.Array(RacialTrait)
    attribute :weight_speeds,       WeightSpeeds
    attribute :feat_ids,            Types.Array(Types::Any)
    attribute :size,                Types::Nil
    attribute :size_id,             Types::Integer
    attribute :sources,             Types.Array(Source)

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        is_sub_race:         d.fetch("isSubRace"),
        base_race_name:      d.fetch("baseRaceName"),
        entity_race_id:      d.fetch("entityRaceId"),
        entity_race_type_id: d.fetch("entityRaceTypeId"),
        definition_key:      d.fetch("definitionKey"),
        full_name:           d.fetch("fullName"),
        base_race_id:        d.fetch("baseRaceId"),
        base_race_type_id:   d.fetch("baseRaceTypeId"),
        description:         d.fetch("description"),
        avatar_url:          d.fetch("avatarUrl"),
        large_avatar_url:    d.fetch("largeAvatarUrl"),
        portrait_avatar_url: d.fetch("portraitAvatarUrl"),
        more_details_url:    d.fetch("moreDetailsUrl"),
        is_homebrew:         d.fetch("isHomebrew"),
        is_legacy:           d.fetch("isLegacy"),
        group_ids:           d.fetch("groupIds"),
        race_type:           d.fetch("type"),
        supports_subrace:    d.fetch("supportsSubrace"),
        sub_race_short_name: d.fetch("subRaceShortName"),
        base_name:           d.fetch("baseName"),
        racial_traits:       d.fetch("racialTraits").map { |x| RacialTrait.from_dynamic!(x) },
        weight_speeds:       WeightSpeeds.from_dynamic!(d.fetch("weightSpeeds")),
        feat_ids:            d.fetch("featIds"),
        size:                d.fetch("size"),
        size_id:             d.fetch("sizeId"),
        sources:             d.fetch("sources").map { |x| Source.from_dynamic!(x) },
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "isSubRace"         => is_sub_race,
        "baseRaceName"      => base_race_name,
        "entityRaceId"      => entity_race_id,
        "entityRaceTypeId"  => entity_race_type_id,
        "definitionKey"     => definition_key,
        "fullName"          => full_name,
        "baseRaceId"        => base_race_id,
        "baseRaceTypeId"    => base_race_type_id,
        "description"       => description,
        "avatarUrl"         => avatar_url,
        "largeAvatarUrl"    => large_avatar_url,
        "portraitAvatarUrl" => portrait_avatar_url,
        "moreDetailsUrl"    => more_details_url,
        "isHomebrew"        => is_homebrew,
        "isLegacy"          => is_legacy,
        "groupIds"          => group_ids,
        "type"              => race_type,
        "supportsSubrace"   => supports_subrace,
        "subRaceShortName"  => sub_race_short_name,
        "baseName"          => base_name,
        "racialTraits"      => racial_traits.map { |x| x.to_dynamic },
        "weightSpeeds"      => weight_speeds.to_dynamic,
        "featIds"           => feat_ids,
        "size"              => size,
        "sizeId"            => size_id,
        "sources"           => sources.map { |x| x.to_dynamic },
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Traits < Dry::Struct
    attribute :personality_traits, Types::String
    attribute :ideals,             Types::String
    attribute :bonds,              Types::String
    attribute :flaws,              Types::String
    attribute :appearance,         Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        personality_traits: d.fetch("personalityTraits"),
        ideals:             d.fetch("ideals"),
        bonds:              d.fetch("bonds"),
        flaws:              d.fetch("flaws"),
        appearance:         d.fetch("appearance"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "personalityTraits" => personality_traits,
        "ideals"            => ideals,
        "bonds"             => bonds,
        "flaws"             => flaws,
        "appearance"        => appearance,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end

  class Character < Dry::Struct
    attribute :id,                         Types::Integer
    attribute :user_id,                    Types::Integer
    attribute :username,                   Types::String
    attribute :is_assigned_to_player,      Types::Bool
    attribute :readonly_url,               Types::String
    attribute :decorations,                Decorations
    attribute :character_name,             Types::String
    attribute :social_name,                Types::Nil
    attribute :gender,                     Types::String
    attribute :faith,                      Types::String
    attribute :age,                        Types::Integer
    attribute :hair,                       Types::String
    attribute :eyes,                       Types::String
    attribute :skin,                       Types::String
    attribute :height,                     Types::String
    attribute :weight,                     Types::Integer
    attribute :inspiration,                Types::Bool
    attribute :base_hit_points,            Types::Integer
    attribute :bonus_hit_points,           Types::Nil
    attribute :override_hit_points,        Types::Nil
    attribute :removed_hit_points,         Types::Integer
    attribute :temporary_hit_points,       Types::Integer
    attribute :current_xp,                 Types::Integer
    attribute :alignment_id,               Types::Integer
    attribute :lifestyle_id,               Types::Integer
    attribute :stats,                      Types.Array(Stat)
    attribute :bonus_stats,                Types.Array(Stat)
    attribute :override_stats,             Types.Array(Stat)
    attribute :background,                 CharacterBackground
    attribute :race,                       Race
    attribute :race_definition_id,         Types::Nil
    attribute :race_definition_type_id,    Types::Nil
    attribute :notes,                      Notes
    attribute :traits,                     Traits
    attribute :preferences,                Preferences
    attribute :configuration,              Configuration
    attribute :lifestyle,                  Types::Nil
    attribute :inventory,                  Types.Array(Inventory)
    attribute :currencies,                 Currencies
    attribute :classes,                    Types.Array(CharacterClass)
    attribute :feats,                      Types.Array(Feat)
    attribute :features,                   Types.Array(Types::Any)
    attribute :custom_defense_adjustments, Types.Array(Types::Any)
    attribute :custom_senses,              Types.Array(Types::Any)
    attribute :custom_speeds,              Types.Array(Types::Any)
    attribute :custom_proficiencies,       Types.Array(Types::Any)
    attribute :custom_actions,             Types.Array(Types::Any)
    attribute :character_values,           Types.Array(Types::Any)
    attribute :conditions,                 Types.Array(Types::Any)
    attribute :death_saves,                DeathSaves
    attribute :adjustment_xp,              Types::Nil
    attribute :spell_slots,                Types.Array(PactMagic)
    attribute :pact_magic,                 Types.Array(PactMagic)
    attribute :active_source_categories,   Types.Array(Types::Integer)
    attribute :spells,                     Actions
    attribute :character_options,          Options
    attribute :choices,                    Choices
    attribute :actions,                    Actions
    attribute :modifiers,                  Modifiers
    attribute :class_spells,               Types.Array(ClassSpell)
    attribute :custom_items,               Types.Array(Types::Any)
    attribute :campaign,                   Campaign
    attribute :creatures,                  Types.Array(Types::Any)
    attribute :optional_origins,           Types.Array(Types::Any)
    attribute :optional_class_features,    Types.Array(Types::Any)
    attribute :date_modified,              Types::String
    attribute :provided_from,              Types::String
    attribute :can_edit,                   Types::Bool
    attribute :status,                     Types::Integer
    attribute :status_slug,                Types::String
    attribute :campaign_setting,           Types::Nil

    def self.from_dynamic!(d)
      d = Types::Hash[d]
      new(
        id:                         d.fetch("id"),
        user_id:                    d.fetch("userId"),
        username:                   d.fetch("username"),
        is_assigned_to_player:      d.fetch("isAssignedToPlayer"),
        readonly_url:               d.fetch("readonlyUrl"),
        decorations:                Decorations.from_dynamic!(d.fetch("decorations")),
        character_name:             d.fetch("name"),
        social_name:                d.fetch("socialName"),
        gender:                     d.fetch("gender"),
        faith:                      d.fetch("faith"),
        age:                        d.fetch("age"),
        hair:                       d.fetch("hair"),
        eyes:                       d.fetch("eyes"),
        skin:                       d.fetch("skin"),
        height:                     d.fetch("height"),
        weight:                     d.fetch("weight"),
        inspiration:                d.fetch("inspiration"),
        base_hit_points:            d.fetch("baseHitPoints"),
        bonus_hit_points:           d.fetch("bonusHitPoints"),
        override_hit_points:        d.fetch("overrideHitPoints"),
        removed_hit_points:         d.fetch("removedHitPoints"),
        temporary_hit_points:       d.fetch("temporaryHitPoints"),
        current_xp:                 d.fetch("currentXp"),
        alignment_id:               d.fetch("alignmentId"),
        lifestyle_id:               d.fetch("lifestyleId"),
        stats:                      d.fetch("stats").map { |x| Stat.from_dynamic!(x) },
        bonus_stats:                d.fetch("bonusStats").map { |x| Stat.from_dynamic!(x) },
        override_stats:             d.fetch("overrideStats").map { |x| Stat.from_dynamic!(x) },
        background:                 CharacterBackground.from_dynamic!(d.fetch("background")),
        race:                       Race.from_dynamic!(d.fetch("race")),
        race_definition_id:         d.fetch("raceDefinitionId"),
        race_definition_type_id:    d.fetch("raceDefinitionTypeId"),
        notes:                      Notes.from_dynamic!(d.fetch("notes")),
        traits:                     Traits.from_dynamic!(d.fetch("traits")),
        preferences:                Preferences.from_dynamic!(d.fetch("preferences")),
        configuration:              Configuration.from_dynamic!(d.fetch("configuration")),
        lifestyle:                  d.fetch("lifestyle"),
        inventory:                  d.fetch("inventory").map { |x| Inventory.from_dynamic!(x) },
        currencies:                 Currencies.from_dynamic!(d.fetch("currencies")),
        classes:                    d.fetch("classes").map { |x| CharacterClass.from_dynamic!(x) },
        feats:                      d.fetch("feats").map { |x| Feat.from_dynamic!(x) },
        features:                   d.fetch("features"),
        custom_defense_adjustments: d.fetch("customDefenseAdjustments"),
        custom_senses:              d.fetch("customSenses"),
        custom_speeds:              d.fetch("customSpeeds"),
        custom_proficiencies:       d.fetch("customProficiencies"),
        custom_actions:             d.fetch("customActions"),
        character_values:           d.fetch("characterValues"),
        conditions:                 d.fetch("conditions"),
        death_saves:                DeathSaves.from_dynamic!(d.fetch("deathSaves")),
        adjustment_xp:              d.fetch("adjustmentXp"),
        spell_slots:                d.fetch("spellSlots").map { |x| PactMagic.from_dynamic!(x) },
        pact_magic:                 d.fetch("pactMagic").map { |x| PactMagic.from_dynamic!(x) },
        active_source_categories:   d.fetch("activeSourceCategories"),
        spells:                     Actions.from_dynamic!(d.fetch("spells")),
        character_options:          Options.from_dynamic!(d.fetch("options")),
        choices:                    Choices.from_dynamic!(d.fetch("choices")),
        actions:                    Actions.from_dynamic!(d.fetch("actions")),
        modifiers:                  Modifiers.from_dynamic!(d.fetch("modifiers")),
        class_spells:               d.fetch("classSpells").map { |x| ClassSpell.from_dynamic!(x) },
        custom_items:               d.fetch("customItems"),
        campaign:                   Campaign.from_dynamic!(d.fetch("campaign")),
        creatures:                  d.fetch("creatures"),
        optional_origins:           d.fetch("optionalOrigins"),
        optional_class_features:    d.fetch("optionalClassFeatures"),
        date_modified:              d.fetch("dateModified"),
        provided_from:              d.fetch("providedFrom"),
        can_edit:                   d.fetch("canEdit"),
        status:                     d.fetch("status"),
        status_slug:                d.fetch("statusSlug"),
        campaign_setting:           d.fetch("campaignSetting"),
      )
    end

    def self.from_json!(json)
      from_dynamic!(JSON.parse(json))
    end

    def to_dynamic
      {
        "id"                       => id,
        "userId"                   => user_id,
        "username"                 => username,
        "isAssignedToPlayer"       => is_assigned_to_player,
        "readonlyUrl"              => readonly_url,
        "decorations"              => decorations.to_dynamic,
        "name"                     => character_name,
        "socialName"               => social_name,
        "gender"                   => gender,
        "faith"                    => faith,
        "age"                      => age,
        "hair"                     => hair,
        "eyes"                     => eyes,
        "skin"                     => skin,
        "height"                   => height,
        "weight"                   => weight,
        "inspiration"              => inspiration,
        "baseHitPoints"            => base_hit_points,
        "bonusHitPoints"           => bonus_hit_points,
        "overrideHitPoints"        => override_hit_points,
        "removedHitPoints"         => removed_hit_points,
        "temporaryHitPoints"       => temporary_hit_points,
        "currentXp"                => current_xp,
        "alignmentId"              => alignment_id,
        "lifestyleId"              => lifestyle_id,
        "stats"                    => stats.map { |x| x.to_dynamic },
        "bonusStats"               => bonus_stats.map { |x| x.to_dynamic },
        "overrideStats"            => override_stats.map { |x| x.to_dynamic },
        "background"               => background.to_dynamic,
        "race"                     => race.to_dynamic,
        "raceDefinitionId"         => race_definition_id,
        "raceDefinitionTypeId"     => race_definition_type_id,
        "notes"                    => notes.to_dynamic,
        "traits"                   => traits.to_dynamic,
        "preferences"              => preferences.to_dynamic,
        "configuration"            => configuration.to_dynamic,
        "lifestyle"                => lifestyle,
        "inventory"                => inventory.map { |x| x.to_dynamic },
        "currencies"               => currencies.to_dynamic,
        "classes"                  => classes.map { |x| x.to_dynamic },
        "feats"                    => feats.map { |x| x.to_dynamic },
        "features"                 => features,
        "customDefenseAdjustments" => custom_defense_adjustments,
        "customSenses"             => custom_senses,
        "customSpeeds"             => custom_speeds,
        "customProficiencies"      => custom_proficiencies,
        "customActions"            => custom_actions,
        "characterValues"          => character_values,
        "conditions"               => conditions,
        "deathSaves"               => death_saves.to_dynamic,
        "adjustmentXp"             => adjustment_xp,
        "spellSlots"               => spell_slots.map { |x| x.to_dynamic },
        "pactMagic"                => pact_magic.map { |x| x.to_dynamic },
        "activeSourceCategories"   => active_source_categories,
        "spells"                   => spells.to_dynamic,
        "options"                  => character_options.to_dynamic,
        "choices"                  => choices.to_dynamic,
        "actions"                  => actions.to_dynamic,
        "modifiers"                => modifiers.to_dynamic,
        "classSpells"              => class_spells.map { |x| x.to_dynamic },
        "customItems"              => custom_items,
        "campaign"                 => campaign.to_dynamic,
        "creatures"                => creatures,
        "optionalOrigins"          => optional_origins,
        "optionalClassFeatures"    => optional_class_features,
        "dateModified"             => date_modified,
        "providedFrom"             => provided_from,
        "canEdit"                  => can_edit,
        "status"                   => status,
        "statusSlug"               => status_slug,
        "campaignSetting"          => campaign_setting,
      }
    end

    def to_json(options = nil)
      JSON.generate(to_dynamic, options)
    end
  end
end
