/*
    Copyright 2016 Daniel Schopf <schopfdan@gmail.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0

import org.kde.plasma.plasmoid 2.0

import "../code/tools.js" as Tools

Item {
    id:main

    property var qwr: Qt.createQmlObject('import org.kde.private.qalculate 1.0 as QWR; QWR.QWrapper {}', main, 'QWrapper')

    property bool fromCompact: false
    property bool debugLogging: false

    property int timeout: plasmoid.configuration.timeout

    property int unitConversion: plasmoid.configuration.unitConversion
    property int structuringMode: plasmoid.configuration.structuringMode
    property string decimalSeparator: plasmoid.configuration.decimalSeparator
    property int angleUnit: plasmoid.configuration.angleUnit
    property int expressionBase: plasmoid.configuration.expressionBase
    property int resultBase: plasmoid.configuration.resultBase

    property int numberFractionFormat: plasmoid.configuration.numberFractionFormat
    property int numericalDisplay: plasmoid.configuration.numericalDisplay
    property bool indicateInfiniteSeries: plasmoid.configuration.indicateInfiniteSeries
    property bool useAllPrefixes: plasmoid.configuration.useAllPrefixes
    property bool useDenominatorPrefix: plasmoid.configuration.useDenominatorPrefix
    property bool negativeExponents: plasmoid.configuration.negativeExponents

    property Component cr: CompactRepresentation { }
    property Component fr: FullRepresentation { }
    property Component frFailed: FullRepresentationFailed { }

    function dbgprint(msg) {
        if (!debugLogging) {
            return
        }
        print('[Qalculate!] ' + msg)
    }

    Plasmoid.icon: plasmoid.configuration.qalculateIcon
    Plasmoid.toolTipMainText: "Qalculate!"

    Plasmoid.compactRepresentation: cr
    Plasmoid.fullRepresentation: fr

    Component.onCompleted: {
      if (qwr == null) {
        Plasmoid.fullRepresentation = frFailed
        return
      }
      if (!plasmoid.configuration.qalculateIcon)
        plasmoid.configuration.qalculateIcon = Tools.stripProtocol(Qt.resolvedUrl('../images/Qalculate.svg'))
      if (plasmoid.configuration.updateExchangeRatesAtStartup) {
        qwr.updateExchangeRates()
      } else {
        plasmoid.configuration.exchangeRatesTime = qwr.getExchangeRatesUpdateTime()
      }
    }

    Component.onDestruction: {
      if (qwr !== null)
        qwr.destroy()
    }

    onUnitConversionChanged: {
      qwr.setAutoPostConversion(unitConversion)
    }

    onStructuringModeChanged: {
      qwr.setStructuringMode(structuringMode)
    }

    onAngleUnitChanged: {
      qwr.setAngleUnit(angleUnit)
    }

    onExpressionBaseChanged: {
      qwr.setExpressionBase(expressionBase)
    }

    onResultBaseChanged: {
      qwr.setResultBase(resultBase)
    }

    onNumberFractionFormatChanged: {
      qwr.setNumberFractionFormat(numberFractionFormat)
    }

    onNumericalDisplayChanged: {
      qwr.setNumericalDisplay(numericalDisplay)
    }

    onIndicateInfiniteSeriesChanged: {
      qwr.setIndicateInfiniteSeries(indicateInfiniteSeries)
    }

    onUseAllPrefixesChanged: {
      qwr.setUseAllPrefixes(useAllPrefixes)
    }

    onUseDenominatorPrefixChanged: {
      qwr.setUseDenominatorPrefix(useDenominatorPrefix)
    }

    onNegativeExponentsChanged: {
      qwr.setNegativeExponents(negativeExponents)
    }

    onDecimalSeparatorChanged: {
      qwr.setDecimalSeparator(decimalSeparator)
    }

    onTimeoutChanged: {
      qwr.setTimeout(timeout)
    }

    Connections {
      target: qwr
      onExchangeRatesUpdated: {
        plasmoid.configuration.exchangeRatesTime = date
      }
    }
}
